import { randomString } from "../utils/random";

interface EliminationEntity {
  id: string;
  phase_id: string;
}

const randomElimination = (phaseId: string) => ({
  info: randomString(),
  order: 1,
  phase_id: phaseId,
  team_stats: [
    {
      placeholder: "some placeholder",
      stats: {
        some_stat_id: "stat value",
      },
      team_id: "some-team-ai",
    },
  ],
  title: randomString(),
});

export const eliminationPayload = (phaseId: string) => (
  {
    elimination: randomElimination(phaseId),
  });

export const eliminationsPatchPayload = (eliminations: EliminationEntity[]) => ({
  eliminations: eliminations.map((elimination: EliminationEntity) => {
    const someElimination = randomElimination(elimination.phase_id);

    return {
      ...someElimination,
      id: elimination.id,
    };
  }),
});
