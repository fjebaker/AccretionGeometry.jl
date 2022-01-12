module AccretionGeometry

import GeodesicTracer: tracegeodesics, DiscreteCallback, terminate!
import GeodesicRendering: rendergeodesics
import Base: in
import RecursiveArrayTools: ArrayPartition
import GeometryBasics
import LinearAlgebra: ×, ⋅

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

add_collision_callback(::Nothing, accretion_geometry) = build_collision_callback(accretion_geometry)
add_collision_callback(callback::Base.AbstractVecOrTuple, accretion_geometry) = (callback..., build_collision_callback(accretion_geometry))
add_collision_callback(callback, accretion_geometry) = (callback, build_collision_callback(accretion_geometry))

function build_collision_callback(geometry::AbstractAccretionGeometry{T}) where {T}
    DiscreteCallback(
        collision_callback(geometry)
        i->terminate!(i, :Intersected)
    )
end

export tracegeodesics, rendergeodesics

end # module
