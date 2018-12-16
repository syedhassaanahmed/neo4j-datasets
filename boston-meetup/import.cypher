// Import Groups and Topics
CREATE CONSTRAINT ON (g:Group) ASSERT g.id IS UNIQUE;
CREATE CONSTRAINT ON (t:Topic) ASSERT t.id IS UNIQUE;
CREATE INDEX ON :Group(name);
CREATE INDEX ON :Topic(name);

LOAD CSV WITH HEADERS
FROM "https://raw.githubusercontent.com/johnymontana/harvard-bar/master/data/groups.csv"
AS row
MERGE (group:Group { id:row.id })
ON CREATE SET
  group.name = row.name,
  group.urlname = row.urlname,
  group.rating = toInt(row.rating),
  group.created = toInt(row.created);

LOAD CSV WITH HEADERS FROM "https://raw.githubusercontent.com/johnymontana/harvard-bar/master/data/groups_topics.csv"  AS row
MERGE (topic:Topic {id: row.id})
ON CREATE SET topic.name = row.name, topic.urlkey = row.urlkey;

LOAD CSV WITH HEADERS FROM "https://raw.githubusercontent.com/johnymontana/harvard-bar/master/data/groups_topics.csv"  AS row
MATCH (topic:Topic {id: row.id})
MATCH (group:Group {id: row.groupId})
MERGE (group)-[:HAS_TOPIC]->(topic);

// My Similar Groups
CREATE CONSTRAINT ON (m:Member) ASSERT m.id IS UNIQUE;

USING PERIODIC COMMIT 10000
LOAD CSV WITH HEADERS
FROM "https://raw.githubusercontent.com/johnymontana/harvard-bar/master/data/members.csv" AS row
WITH DISTINCT row.id AS id, row.name AS name
MERGE (member:Member {id: id})
ON CREATE SET member.name = name;

USING PERIODIC COMMIT 10000
LOAD CSV WITH HEADERS
FROM "https://raw.githubusercontent.com/johnymontana/harvard-bar/master/data/members.csv" AS row
WITH row WHERE NOT row.joined is null
MATCH (member:Member {id: row.id})
MATCH (group:Group {id: row.groupId})
MERGE (member)-[membership:MEMBER_OF]->(group)
ON CREATE SET membership.joined=toInt(row.joined);

CREATE INDEX ON :Member(name);

// Events
CREATE CONSTRAINT ON (e:Event) ASSERT e.id IS UNIQUE;
CREATE INDEX ON :Event(time);

USING PERIODIC COMMIT 10000
LOAD CSV WITH HEADERS FROM "https://raw.githubusercontent.com/johnymontana/harvard-bar/master/data/events.csv" AS row
MERGE (event:Event {id: row.id})
ON CREATE SET event.name = row.name,
              event.description = row.description,
              event.time = toInt(row.time),
              event.utcOffset = toInt(row.utc_offset);

USING PERIODIC COMMIT 10000
LOAD CSV WITH HEADERS FROM "https://raw.githubusercontent.com/johnymontana/harvard-bar/master/data/events.csv" AS row
WITH distinct row.group_id as groupId, row.id as eventId
MATCH (group:Group {id: groupId})
MATCH (event:Event {id: eventId})
MERGE (group)-[:HOSTED_EVENT]->(event);

// Adding Member RSVPs
USING PERIODIC COMMIT 10000
LOAD CSV WITH HEADERS FROM "https://raw.githubusercontent.com/johnymontana/harvard-bar/master/data/rsvps.csv" AS row
WITH row WHERE row.response = "yes"

MATCH (member:Member {id: row.member_id})
MATCH (event:Event {id: row.event_id})
MERGE (member)-[rsvp:RSVPD {id: row.rsvp_id}]->(event)
ON CREATE SET rsvp.created = toint(row.created),
              rsvp.lastModified = toint(row.mtime),
              rsvp.guests = toint(row.guests);

// Extracting keywords from event descriptions
CREATE CONSTRAINT ON (k:Keyword) ASSERT k.name IS UNIQUE;