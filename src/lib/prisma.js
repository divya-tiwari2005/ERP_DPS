
import "dotenv/config";

import { PrismaClient } from "../../generated/prisma/client.ts";
import { PrismaMariaDb } from "@prisma/adapter-mariadb";

const adapter = new PrismaMariaDb({
  host: "127.0.0.1",
  port: 3308,
  user: "root",
  password: process.env.MYSQL_PASSWORD,
  database: "school_erp",

  allowPublicKeyRetrieval: true,
  
  // Keep the pool deliberately small for now.
  connectionLimit: 5,

  // How long to wait for a free pool connection.
  acquireTimeout: 10000,

  // How long to establish a new DB connection.
  connectTimeout: 5000,

  // Close connections that have been idle for this period.
  idleTimeout: 300,
});

const prisma = new PrismaClient({
  adapter,
});

export default prisma;

