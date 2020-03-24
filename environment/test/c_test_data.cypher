CREATE (p:Player { id:"player1hash", name:"Player 1", created:TIMESTAMP(), email:"player1@mail.com", password:"Player1" });
CREATE (p:Player { id:"player2hash", name:"Player 2", created:TIMESTAMP(), email:"player2@mail.com", password:"Player2" });

MATCH 
  (at:Archetype), (f:Faction), (pu:PointsUpdate) 
WHERE 
  at.id = "ace" 
  AND f.id = "rebel" 
  AND pu.id = "pointsupdate20192"
CREATE 
  (f)<-[:Belongs]-
  (sq:Squad {id:"squad1hash", name:"First Squad", created:TIMESTAMP()})
  -[:Is]->(at),
  (sq)-[:Comply]->(pu);


CREATE
  (:Card:Pilot {id:"lukeskywalker", name:"Luke Skywalker", created:TIMESTAMP()})-[:Flies]->(:Frame {id:"t65xwing", name:"T-65 X-Wing", created:TIMESTAMP()}),
  (:Card:Force {id:"brilliantevasion", name:"Brillian Evasion", created:TIMESTAMP()}),
  (:Card:Astromech {id:"r3astromech", name:"R3 Astromech", created:TIMESTAMP()}),
  (:Card:Torpedo {id:"protontorpedoes", name:"Proton Torpedoes", created:TIMESTAMP()});

MATCH
  (sq:Squad), (pilot:Pilot), (force:Force), (astromech:Astromech), (torpedo:Torpedo)
WHERE 
  sq.id = "squad1hash"
  AND pilot.id = "lukeskywalker"
  AND force.id = "brilliantevasion"
  AND astromech.id = "r3astromech"
  AND torpedo.id = "protontorpedoes"
CREATE
  (sq)-[:Includes]->(s:Ship {id:"ship1hash", name:"Luke Skywalker", created:TIMESTAMP()}),
  (s)-[:Use {points: 62}]->(pilot),
  (s)-[:Use {points: 3}]->(force),
  (s)-[:Use {points: 3}]->(astromech),
  (s)-[:Use {points: 13}]->(torpedo);


MATCH
  (s:Ship)
WHERE
  s.id = "t65xwing"
CREATE
  (:Card:Pilot {id:"redsquadronveteran", name:"Red Squadron Veteran", created:TIMESTAMP()})-[:Flies]->(s),
  (:Card:Talent {id:"crackshot", name:"Crack Shot", created:TIMESTAMP()}),
  (:Card:Torpedo {id:"plasmatorpedoes", name:"Plasma Torpedoes", created:TIMESTAMP()});

MATCH
  (sq:Squad), (pilot:Pilot), (talent:Talent), (astromech:Astromech), (torpedo:Torpedo)
WHERE 
  sq.id = "squad1hash"
  AND pilot.id = "redsquadronveteran"
  AND talent.id = "crackshot"
  AND astromech.id = "r3astromech"
  AND torpedo.id = "plasmatorpedoes"
CREATE
  (sq)-[:Includes]->(s1:Ship {id:"ship2hash", name:"Red Squadron Veteran", created:TIMESTAMP()}),
  (s1)-[:Use {points: 41}]->(pilot),
  (s1)-[:Use {points: 1}]->(talent),
  (s1)-[:Use {points: 3}]->(astromech),
  (s1)-[:Use {points: 3}]->(torpedo),
  (sq)-[:Includes]->(s2:Ship {id:"ship3hash", name:"Red Squadron Veteran", created:TIMESTAMP()}),
  (s2)-[:Use {points: 41}]->(pilot),
  (s2)-[:Use {points: 1}]->(talent),
  (s2)-[:Use {points: 3}]->(astromech),
  (s2)-[:Use {points: 3}]->(torpedo);


MATCH 
  (at:Archetype), (f:Faction), (pu:PointsUpdate)  
WHERE 
  at.id = "swarm" 
  AND f.id = "rebel" 
  AND pu.id = "pointsupdate20192"
CREATE 
  (f)<-[:Belongs]-
  (sq:Squad {id:"squad2hash", name:"Second Squad", created:TIMESTAMP()})
  -[:Is]->(at),
  (sq)-[:Comply]->(pu);


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