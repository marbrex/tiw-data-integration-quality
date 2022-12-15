// TIW IQD - TP Neo4j
// Etudiant: Eldar Kasmamytov p1712650

// ========================================================
// ===================== SECTION II =======================
// ========================================================

// Q1
MATCH (n) RETURN DISTINCT labels(n) as Labels;

// Q2
MATCH (a)-[r]-(b) RETURN DISTINCT type(r) as Relations;

// Q3 (Noeuds)
MATCH (n) 
WITH labels(n) AS labels, keys(n) AS keys
UNWIND labels AS label
UNWIND keys AS key
RETURN DISTINCT label, collect(DISTINCT key) AS properties
ORDER BY label;

// Q3 (Relations)
MATCH ()-[r]-()
RETURN DISTINCT type(r) as Relation, keys(r) as Keys
ORDER BY Relation;

// =======================================================
// ==================== SECTION III ======================
// =======================================================

// Q1
MATCH (pg:Pangenome)<-[:IS_IN_PANGENOME]-(f:Family)
WHERE f.annotation IS NOT null
RETURN pg.name as Nom, count(f) as Count;

// Q2
MATCH (pg:Pangenome)<-[:IS_IN_PANGENOME]-(f:Family)-[:HAS_PARTITION]->(p:Partition)
WHERE f.annotation IS NOT null AND p.partition IN ['cloud', 'shell']
RETURN pg.name as Nom, count(f) as Count;

// Q3
MATCH (s:Spot)<-[:IS_IN_SPOT]-(n:RGP)
MATCH (n)<-[:IS_IN_RGP]-(:Gene)-[:IS_IN_FAMILY]->(f:Family)
WHERE f.annotation IS NOT null
RETURN n.name as Nom, count(n.name) as Count, s.name as Hotspot;

// Q4
MATCH (pg:Pangenome)<-[:IS_IN_PANGENOME]-(:Family)<-[:IS_IN_FAMILY]-(:Gene)-[:IS_IN_RGP]->(rgp:RGP)
WITH pg, count(rgp) as cnt
RETURN pg.name as Nom, cnt as Count
ORDER BY cnt DESC
LIMIT 2;

// Q5
MATCH (pg:Pangenome)<-[:IS_IN_PANGENOME]-(f:Family)<-[:IS_IN_FAMILY]-(g:Gene)
MATCH (f)-[:IS_IN_MODULE]->(:Module)
WITH pg, count(g) as cnt
RETURN pg.name as Nom, cnt as Count
ORDER BY cnt DESC
LIMIT 2;

// Q6
MATCH (pg:Pangenome)<-[:IS_IN_PANGENOME]-(:Family)-[:IS_IN_MODULE]->(m:Module)
WITH pg, count(m) as cnt
RETURN pg.name as Nom, cnt as Count
ORDER BY cnt DESC
LIMIT 2;

// ========================================================
// ===================== SECTION IV =======================
// ========================================================

// Q1
MATCH (pg:Pangenome)<-[:IS_IN_PANGENOME]-(:Family)-[:IS_SIMILAR]-(f:Family)-[:HAS_PARTITION]->(p:Partition)
RETURN DISTINCT pg.name as Species,
       f.name as Similar_Family,
       p.partition as Partition
ORDER BY Species;

// Q2
MATCH (f1:Family)-[:IS_SIMILAR]-(f2:Family)
WHERE f1<>f2
MATCH (p1:Pangenome)<-[:IS_IN_PANGENOME]-(f1)-[:IS_IN_MODULE]->(m1:Module)
MATCH (p2:Pangenome)<-[:IS_IN_PANGENOME]-(f2)-[:IS_IN_MODULE]->(m2:Module)
WHERE p1<>p2
RETURN f1.name as Family1,
       f2.name as Family2,
       count(f1.name) as Count1,
       count(f2.name) as Count2,
       m1.name as Module1,
       m2.name as Module2
ORDER BY Family1, Family2, Module1, Module2;

// Q3
MATCH (f1:Family)-[:IS_SIMILAR]-(f2:Family)
WHERE f1<>f2
MATCH (f1)-[:IS_IN_PANGENOME]->(p1:Pangenome)
MATCH (f2)-[:IS_IN_PANGENOME]->(p2:Pangenome)
WHERE p1<>p2
MATCH (f)<-[:IS_IN_FAMILY]-(:Gene)-[:IS_IN_RGP]->(:RGP)-[:IS_IN_SPOT]->(:Spot)
WHERE f=f1 OR f=f2
RETURN DISTINCT f1.name as Family1, f2.name as Family2
ORDER BY Family1, Family2;

// Q4
MATCH (f1:Family)-[r:IS_SIMILAR]-(f2:Family)
WHERE r.identity>0.8 AND r.coverage>0.8
MATCH (pg1:Pangenome)<-[:IS_IN_PANGENOME]-(f1)-[:HAS_PARTITION]->(p1:Partition)
MATCH (pg2:Pangenome)<-[:IS_IN_PANGENOME]-(f2)-[:HAS_PARTITION]->(p2:Partition)
RETURN pg1.name as Species1,
       pg2.name as Species2,
       p1.partition as Part1,
       p2.partition as Part2,
       f1.annotation as Annot1,
       f2.annotation as Annot2
ORDER BY r.identity, r.coverage DESC
LIMIT 1;

