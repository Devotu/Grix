CREATE (p:Player { id:"player1hash", name:"Player 1", created:TIMESTAMP(), email:"player1@mail.com", password:"Player1" });
CREATE (p:Player { id:"player2hash", name:"Player 2", created:TIMESTAMP(), email:"player2@mail.com", password:"Player2" });


MATCH 
  (at:Archetype), (f:Faction) 
WHERE 
  at.id = "Ace" 
  AND f.id = "Rebel" 
CREATE 
  (f)<-[:Belongs]-
  (sq:Squad {id:"squad1hash", name:"First Squad", created:TIMESTAMP()})
  -[:Is]->(at);


MATCH
  (sq:Squad)
WHERE 
  sq.id = "squad1hash"
CREATE
  (sq)-[:Includes]->(s:Ship {id:"ship1hash", name:"First Ship", created:TIMESTAMP()});


MATCH 
  (at:Archetype), (f:Faction) 
WHERE 
  at.id = "Swarm" 
  AND f.id = "Empire" 
CREATE 
  (f)<-[:Belongs]-
  (sq:Squad {id:"squad2hash", name:"Second Squad", created:TIMESTAMP()})
  -[:Is]->(at);


MATCH 
  (p:Player)
WHERE 
  p.id = "player1hash"
CREATE
  (p)-[:Registered]->(g:Game {id:"game1hash", created:TIMESTAMP()});

MATCH 
  (p:Player), (sq:Squad), (g:Game)
WHERE 
  p.id = "player1hash"
  AND sq.id = "squad1hash"
  AND g.id = "game1hash"
CREATE
  (p)-[:Got]->
  (s:Score {id:"score1hash", points:120, created:TIMESTAMP()})
  -[:With]->(sq),
  (s)-[:In]->(g);

MATCH 
  (p:Player), (sq:Squad), (g:Game)
WHERE 
  p.id = "player2hash"
  AND sq.id = "squad2hash"
  AND g.id = "game1hash"
CREATE
  (p)-[:Got]->
  (s:Score {id:"score2hash", points:90, created:TIMESTAMP()})
  -[:With]->(sq),
  (s)-[:In]->(g);


MATCH 
  (p:Player)
WHERE 
  p.id = "player1hash"
CREATE
  (p)-[:Registered]->(g:Game {id:"game2hash", created:TIMESTAMP()});

MATCH 
  (p:Player), (sq:Squad), (g:Game)
WHERE 
  p.id = "player1hash"
  AND sq.id = "squad1hash"
  AND g.id = "game2hash"
CREATE
  (p)-[:Got]->
  (s:Score {id:"score3hash", points:80, created:TIMESTAMP()})
  -[:With]->(sq),
  (s)-[:In]->(g);

MATCH 
  (p:Player), (sq:Squad), (g:Game)
WHERE 
  p.id = "player2hash"
  AND sq.id = "squad2hash"
  AND g.id = "game2hash"
CREATE
  (p)-[:Got]->
  (s:Score {id:"score4hash", points:102, created:TIMESTAMP()})
  -[:With]->(sq),
  (s)-[:In]->(g);


MATCH 
  (p:Player)
WHERE 
  p.id = "player1hash"
CREATE
  (p)-[:Registered]->(g:Game {id:"game3hash", created:TIMESTAMP()});