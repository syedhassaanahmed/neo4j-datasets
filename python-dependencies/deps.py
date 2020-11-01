import requests
import csv

from neo4j import GraphDatabase

def process_deps(items, parent=None):
    for item in items:
        yield (parent, item["key"])
        yield from process_deps(item["dependencies"], item["key"])

driver = GraphDatabase.driver("bolt://localhost", auth=("neo4j", "neo"))

r = requests.get("https://gist.github.com/mneedham/4ac262fa5a369de4d3ceb1f3eb1b8c08/raw")
response = r.json()

with driver.session() as session:
    for parent, library in process_deps(response):
        params = {
            "library": library,
            "parent": parent
        }
        result = session.run("""\
        MERGE (l:Library {name: $library})
        WITH l
        CALL apoc.do.when(
            $parent is null,
            "RETURN library, null as parent",
            "WITH $library AS library
             MERGE (parent:Library {name: $parent})
             MERGE (parent)-[:DEPENDS_ON]->(library)
             RETURN library, parent",
            {library: l, parent: $parent})
        YIELD value
        RETURN value
        """, params)
        print(result.peek())
