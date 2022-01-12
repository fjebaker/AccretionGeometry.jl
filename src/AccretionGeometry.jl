module AccretionGeometry

import GeodesicTracer: tracegeodesics
import GeodesicRendering: rendergeodesics

include("callbacks.jl")

function tracegeodesics(
    m::AbstractMetricParams{T},
    init_positions,
    init_velocities,
    time_domain::Tuple{T,T}
    accretion_geometry # new argument
    ;
    callback=nothing,
    kwargs...
) where {T}
    cbs = add_collision_callback(callback, accretion_geometry)
    tracegeodesics(m, init_positions, init_velocities, time_domain; callback=cbs, kwargs...)
end

function rendergeodesics(
    m::AbstractMetricParams{T},
    init_pos,
    max_time::T,
    accretion_geometry
    ;
    callback=nothing,
    kwargs...,
) where {T}
    cbs = add_collision_callback(callback, accretion_geometry)
    rendergeodesics(m, init_pos, max_time; callback=cbs, kwargs...)
end

add_collision_callback(::Nothing, accretion_geometry) = collision_callback(accretion_geometry)
add_collision_callback(callback, accretion_geometry) = (callback..., collision_callback(accretion_geometry))

end # module
