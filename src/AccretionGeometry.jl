module AccretionGeometry

import GeodesicTracer: tracegeodesics, DiscreteCallback
import GeodesicRendering: rendergeodesics
import Base: in
import GeometryBasics

using GeodesicBase
using StaticArrays

include("geometry.jl")
include("meshes.jl")
include("intersections.jl")

function tracegeodesics(
    m::AbstractMetricParams{T},
    init_positions,
    init_velocities,
    time_domain::Tuple{T,T},
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

collision_callback(geometry) = DiscreteCallback(
    (u, λ, integrator) -> intersects_geometry(geometry, line_element(u, integrator)),
    i->terminate!(i, retcode=:Intersected)
)

end # module
