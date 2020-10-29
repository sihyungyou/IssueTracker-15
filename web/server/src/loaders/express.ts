import express, { Request, Response } from "express";
import cors from "cors";
import bodyParser from "body-parser";
import APIRouter from "../routers";
import createDBConnection from "./database";

export default async ({ app }: { app: express.Application }): Promise<void> => {
  await createDBConnection();

  app.use(cors());
  app.use(bodyParser.json());

  app.use("/api", APIRouter);

  app.use("/", (req: Request, res: Response) => {
    res.send("hello");
  });
};