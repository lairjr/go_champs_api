import { randomString } from "../utils/random";

const randomGroup = (tournamentPhaseId: string) => ({
  name: randomString(),
  tournament_phase_id: tournamentPhaseId,
});

export const tournamentGroupPayload = (tournamentPhaseId: string) => (
  {
    tournament_group: randomGroup(tournamentPhaseId),
  });
