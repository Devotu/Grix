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