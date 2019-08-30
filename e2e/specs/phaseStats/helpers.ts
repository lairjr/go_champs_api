import { randomString } from "../utils/random";

const randomStat = (tournamentPhaseId: string) => ({
  title: randomString(),
  tournament_phase_id: tournamentPhaseId,
});

export const tournamentStatPayload = (tournamentPhaseId: string) => (
  {
    tournament_stat: randomStat(tournamentPhaseId),
  });
