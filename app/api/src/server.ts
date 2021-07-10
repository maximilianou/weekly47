//import express, { Express } from 'express';
//import morgan from 'morgan';
//import helmet from 'helmet';
//import cors from 'cors';
import config from '../config.json';

import { Neo4jGraphQL } from '@neo4j/graphql';
import { ApolloServer } from 'apollo-server';
import { typeDefs } from './typeDefinitions';
import { driver } from './driver';

const neo4jGraphQL: Neo4jGraphQL = new Neo4jGraphQL({ typeDefs, driver });
//const app: Express = express();
const app: ApolloServer = new ApolloServer({ schema: neo4jGraphQL.schema});


/************************************************************************************
 *                              Basic Express Middlewares
 ***********************************************************************************/

//app.applyMiddleware(express.json());
//app.use(express.urlencoded({ extended: true }));

// Handle logs in console during development
if (process.env.NODE_ENV === 'development' || config.NODE_ENV === 'development') {
//  app.use(morgan('dev'));
//  app.use(cors());
}

// Handle security and origin in production
if (process.env.NODE_ENV === 'production' || config.NODE_ENV === 'production') {
//  app.use(helmet());
}

/************************************************************************************
 *                               Register all routes
 ***********************************************************************************/


/************************************************************************************
 *                               Express Error Handling
 ***********************************************************************************/

// eslint-disable-next-line @typescript-eslint/no-unused-vars
//app.use((err: Error, req: express.Request, res: express.Response, next: express.NextFunction) => {
//  return res.status(500).json({
//    errorName: err.name,
//    message: err.message,
//    stack: err.stack || 'no stack defined'
//  });
//});

export default app;