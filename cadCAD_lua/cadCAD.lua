function Run_simulation(initial_state, params, timestep_block, timesteps, samples)
    local results = {}
    for sample = 1, samples do
        local state = initial_state
        local new_state
        local history = {}
        for timestep = 1, timesteps do
            history[timestep] = {}
            state.timestep = timestep
            for substep, substep_block in pairs(timestep_block) do
                state.substep = substep
                new_state = state
                for variable, variable_fn in pairs(substep_block) do
                    new_state[variable] = variable_fn(params, substep, history, state)
                end
                history[timestep][substep] = new_state
                state = new_state
            end
        end
        results[sample] = history
    end
    return results
end

function Update_prey_population(params, substep, history, state)
    return state.prey_population + 1
end

function Update_predator_population(params, substep, history, state)
    return state.predator_population + 1
end

Initial_state = {}
Initial_state.prey_population = 5
Initial_state.predator_population = 10

Params = {}

Timestep_block = {}
Timestep_block[1] = {}
Timestep_block[1].prey_population = Update_prey_population
Timestep_block[1].predator_population = Update_predator_population
Timestep_block[2] = {}
Timestep_block[2].prey_population = Update_prey_population
Timestep_block[2].predator_population = Update_predator_population

Samples = 2
Timesteps = 10

Result = Run_simulation(Initial_state, Params, Timestep_block, Timesteps, Samples)

print(Result[2][5][1].prey_population)
