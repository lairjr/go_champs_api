import { randomString } from "../utils/random";

const randomStat = (phaseId: string) => ({
  title: randomString(),
  phase_id: phaseId,
});

export const tournamentStatPayload = (phaseId: string) => (
  {
    tournament_stat: randomStat(phaseId),
  });
