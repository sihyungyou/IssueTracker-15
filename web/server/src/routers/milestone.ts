import express, { Request, Response } from "express";
import MilestoneService from "../services/milestone.service";
import { Milestone } from "../types/milestone.types";

const MilestoneRouter = express.Router();
MilestoneRouter.post("/", async (req: Request, res: Response) => {
  const newMilestoneData: Milestone = req.body;

  try {
    await MilestoneService.createMilestone(newMilestoneData);
    return res.status(200);
  } catch (e) {
    return res.status(400).json(e.message);
  }
});
export default MilestoneRouter;
