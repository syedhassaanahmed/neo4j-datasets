import urllib.request
import re
import spacy
import os
import neo4j

# https://www.gutenberg.org/ebooks/95 Prisoner of Zenda

# Fetch the data
target_url = 'https://www.gutenberg.org/files/95/95-0.txt'
data = urllib.request.urlopen(target_url)
raw_data = data.read().decode('utf8').strip()

# Preprocess text into chapters 
chapters = re.sub('[^A-z0-9 -]', ' ', raw_data).split('CHAPTER')[1:]
chapters[-1] = chapters[-1].split('End of the Project Gutenberg EBook')[0]

# Load an NLP model
nlp = spacy.load("en_core_web_lg", disable=["tagger", "parser"])

# Define cypher queries
host = "bolt://localhost:7687"
user = os.environ["NEO4J_USERNAME"]
password = os.environ["NEO4J_PASSWORD"]

driver = neo4j.GraphDatabase.driver(host, auth=(user, password))

save_query ="""
MERGE (p1:Person{name:$name1})
MERGE (p2:Person{name:$name2})
MERGE (p1)-[r:RELATED]-(p2)
ON CREATE SET r.score = 1
ON MATCH SET r.score = r.score + 1"""

constraint_query="CREATE CONSTRAINT ON (p:Person) ASSERT p.name IS UNIQUE;"

# Run the analysis of the first chapter
c = chapters[0]
# Get involved
doc=nlp(c)

with driver.session() as session:
    #define constraint
    session.run(constraint_query)
    # Extract Person labels
    involved = list(set([ent.text for ent in doc.ents if ent.label_=='PERSON']))
    # Preprocess text
    decode = dict()
    for i,x in enumerate(involved):
        # Get mapping
        decode['$${}$$'.format(i)] = x
        # Preprocess text
        c = c.replace(x,' $${}$$ '.format(i))
        
    # Split chapter into words
    ws = c.split()
    l = len(ws)
    # Iterate through words
    for wi,w in enumerate(ws):
        # Skip if the word is not a person
        if not w[:2] == '$$':
            continue
        # Check next x words for any involved person
        x = 14
        for i in range(wi+1,wi+x):
            # Avoid list index error
            if i >= l:
                break
            # Skip if the word is not a person
            if not ws[i][:2] == '$$':
                continue
            # Store to Neo4j
            params = {'name1':decode[ws[wi]],'name2':decode[ws[i]]}
            session.run(save_query, params)
            print(decode[ws[wi]],decode[ws[i]])

# Run pagerank and louvain algorithm
pagerank ="""
CALL algo.pageRank('Person','RELATED',{direction:'BOTH'})
"""
louvain = """
CALL algo.louvain('Person','RELATED',{direction:'BOTH'})
"""
with driver.session() as session:
    session.run(pagerank)
    session.run(louvain)

# Additional options
# Add orgs
c = chapters[0]
doc = nlp(c)

save_org_query = """

MERGE (p:Person{name:$person})
MERGE (o:Organization{name:$org})
MERGE (p)-[r:PART_OF]->(o)
ON CREATE SET r.score = 1
ON MATCH SET r.score = r.score + 1

"""

with driver.session() as session:
    # Define the mapping
    persons = list(set([ent.text for ent in doc.ents if ent.label_=='PERSON']))
    orgs = list(set([ent.text for ent in doc.ents if ent.label_=='ORG']))
    decode_org = dict()
    decode_person = dict()
    # Replace person
    for i,p in enumerate(persons):
        decode_person['$${}$$'.format(i)] = p
        r = ' $${}$$ '.format(i)
        c = c.replace(p,r)
    # Replace organizations
    for i,o in enumerate(orgs):
        decode_org['&&{}&&'.format(i)] = o
        c = c.replace(o,' &&{}&& '.format(i))    
    # Split chapter into words
    ws = c.split()
    l = len(ws)
    for wi,w in enumerate(ws):
        # Skip if the word is not a organization
        if not w[:2] == '&&':
            continue
        # Check previous and next x words for any involved person
        x = 5
        for i in range(wi-x,wi+x):
            # Avoid list index error
            if i >= l:
                break
            # Skip if the word is not a person
            if (ws[i][:2]!='$$') or (i==wi):
                continue
            # Store to Neo4j
            # Todo: Maybe some automated mapping of name to surnames etc..
            params = {'org':decode_org[ws[wi]],'person':decode_person[ws[i]]}
            session.run(save_org_query, params)
            print(decode_org[ws[wi]],decode_person[ws[i]])