import { randomString } from "../utils/random";

interface PhaseEntity {
  id: string;
  tournament_id: string;
}

const randomPhase = (tournamentId: string) => ({
  title: randomString(),
  tournament_id: tournamentId,
  type: Math.round(Math.random() * 1) ? "elimination" : "draw",
  is_in_progress: Math.round(Math.random() * 1) ? true : false,
});

const randomPhaseWithElimination = (tournamentId: string) => ({
  title: randomString(),
  tournament_id: tournamentId,
  type: "elimination",
  elimination_stats: [
    {
      title: randomString(),
    },
    {
      title: randomString(),
    },
  ],
  is_in_progress: Math.round(Math.random() * 1) ? true : false,
});

export const phasePayload = (tournamentId: string) => (
  {
    phase: randomPhase(tournamentId),
  });

export const phaseWithEliminationPayload = (tournamentId: string) => ({
  phase: randomPhaseWithElimination(tournamentId),
});

export const phasesPatchPayload = (phases: PhaseEntity[]) => ({
  phases: phases.map((phase: PhaseEntity) => {
    const somePhase = randomPhase(phase.tournament_id);

    return {
      ...somePhase,
      id: phase.id,
    };
  }),
});