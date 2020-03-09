CREATE (at:Archetype {id:"none", name:"None", created:TIMESTAMP()});
CREATE (at:Archetype {id:"ace", name:"Aces", created:TIMESTAMP()});
CREATE (at:Archetype {id:"nok", name:"N of a kind", created:TIMESTAMP()});
CREATE (at:Archetype {id:"beef", name:"Beef", created:TIMESTAMP()});
CREATE (at:Archetype {id:"control", name:"Control", created:TIMESTAMP()});
CREATE (at:Archetype {id:"swarm", name:"Swarm", created:TIMESTAMP()});
CREATE (at:Archetype {id:"strike", name:"Alpha Strike", created:TIMESTAMP()});

CREATE (f:Faction {id:"rebel", name:"Rebel", created:TIMESTAMP()});
CREATE (f:Faction {id:"empire", name:"Empire", created:TIMESTAMP()});
CREATE (f:Faction {id:"scum", name:"Scum", created:TIMESTAMP()});
CREATE (f:Faction {id:"resistance", name:"Resistance", created:TIMESTAMP()});
CREATE (f:Faction {id:"order", name:"First Order", created:TIMESTAMP()});
CREATE (f:Faction {id:"republic", name:"Republic", created:TIMESTAMP()});
CREATE (f:Faction {id:"separatist", name:"Separatist", created:TIMESTAMP()});

CREATE (pu:PointsUpdate {id:"pointsupdate20191", name:"2019-1", enumeration:1 , created:TIMESTAMP()});
CREATE (pu:PointsUpdate {id:"pointsupdate20192", name:"2019-2", enumeration:2 , created:TIMESTAMP()});
CREATE (pu:PointsUpdate {id:"pointsupdate20201", name:"2020-1", enumeration:3 , created:TIMESTAMP()});