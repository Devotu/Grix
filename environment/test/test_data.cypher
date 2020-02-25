MATCH (n) DETACH DELETE n;

CREATE (p:Player { id:"p1hash", name:"Player 1", created:TIMESTAMP(), email:"player1@mail.com", password:"Player1" });
CREATE (p:Player { id:"p2hash", name:"Player 2", created:TIMESTAMP(), email:"player2@mail.com", password:"Player2" });
