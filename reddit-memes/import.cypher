WITH 'https://raw.githubusercontent.com/umbrae/reddit-top-2.5-million/master/data/memes.csv' as url
LOAD CSV WITH HEADERS FROM url AS row
CREATE (m:Meme) SET m=row; // we take it all into Meme nodes

MATCH (m:Meme) WITH m
WITH split(reduce(s=toUpper(m.title), c IN split(",!?'.","") | replace(s,c,'')), " ") as words, m
UNWIND range(0,size(words)-2) as idx // turn the range into rows of idx
MERGE (a:Word {text:words[idx]})
MERGE (b:Word {text:words[idx+1]})

// Connect the words via :NEXT and store the meme-ids on each rel in an `ids` property
MERGE (a)-[rel:NEXT]->(b) SET rel.ids = coalesce(rel.ids,[]) + [m.id]

// to later recreate the meme along the next chain
// connect the first word to the meme itself
WITH * WHERE idx = 0
MERGE (m)-[:FIRST]->(a);