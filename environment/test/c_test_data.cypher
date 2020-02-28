CREATE (p:Player { id:"p1hash", name:"Player 1", created:TIMESTAMP(), email:"player1@mail.com", password:"Player1" });
CREATE (p:Player { id:"p2hash", name:"Player 2", created:TIMESTAMP(), email:"player2@mail.com", password:"Player2" });


MATCH 
  (at:Archetype), (f:Faction) 
WHERE 
  at.id = "Ace" 
  AND f.id = "Rebel" 
CREATE 
  (f)<-[:Belongs]-
  (sq:Squad {id:"sq1hash", name:"First Squad", created:TIMESTAMP()})
  -[:Is]->(at);

MATCH 
  (at:Archetype), (f:Faction) 
WHERE 
  at.id = "Swarm" 
  AND f.id = "Empire" 
CREATE 
  (f)<-[:Belongs]-
  (sq:Squad {id:"sq2hash", name:"Second Squad", created:TIMESTAMP()})
  -[:Is]->(at);


MATCH 
  (p:Player)
WHERE 
  p.id = "p1hash"
CREATE
  (p)-[:Registered]->(g:Game {id:"g1hash", created:TIMESTAMP()});

MATCH 
  (p:Player), (sq:Squad), (g:Game)
WHERE 
  p.id = "p1hash"
  AND sq.id = "sq1hash"
  AND g.id = "g1hash"
CREATE
  (p)-[:Got]->
  (s:Score {id:"s1hash", points:120, created:TIMESTAMP()})
  -[:With]->(sq),
  (s)-[:In]->(g);

MATCH 
  (p:Player), (sq:Squad), (g:Game)
WHERE 
  p.id = "p2hash"
  AND sq.id = "sq2hash"
  AND g.id = "g1hash"
CREATE
  (p)-[:Got]->
  (s:Score {id:"s2hash", points:90, created:TIMESTAMP()})
  -[:With]->(sq),
  (s)-[:In]->(g);


MATCH 
  (p:Player)
WHERE 
  p.id = "p1hash"
CREATE
  (p)-[:Registered]->(g:Game {id:"g2hash", created:TIMESTAMP()});

MATCH 
  (p:Player), (sq:Squad), (g:Game)
WHERE 
  p.id = "p1hash"
  AND sq.id = "sq1hash"
  AND g.id = "g2hash"
CREATE
  (p)-[:Got]->
  (s:Score {id:"s3hash", points:80, created:TIMESTAMP()})
  -[:With]->(sq),
  (s)-[:In]->(g);

MATCH 
  (p:Player), (sq:Squad), (g:Game)
WHERE 
  p.id = "p2hash"
  AND sq.id = "sq2hash"
  AND g.id = "g2hash"
CREATE
  (p)-[:Got]->
  (s:Score {id:"s4hash", points:102, created:TIMESTAMP()})
  -[:With]->(sq),
  (s)-[:In]->(g);


MATCH 
  (p:Player)
WHERE 
  p.id = "p1hash"
CREATE
  (p)-[:Registered]->(g:Game {id:"g3hash", created:TIMESTAMP()});