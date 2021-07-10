import neo4j, { Driver } from 'neo4j-driver';

export const driver: Driver = neo4j.driver("bolt://localhost:7687", neo4j.auth.basic("neo4j", "s3cr3t"));

