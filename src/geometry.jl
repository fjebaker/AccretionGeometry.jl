abstract type AbstractAccretionGeometry{T} end
abstract type AbstractAccretionDisc{T} <: AbstractAccretionGeometry{T} end

function to_cartesian(vec::AbstractVector{T}) where {T}
    SVector{3, T}(to_cartesian(vec[2], vec[3], vec[4])...)
end

function to_cartesian(r, ϕ, θ)
    sinϕ = sin(ϕ)
    (r * sinϕ * cos(θ), r * sinϕ * sin(θ), r * cos(ϕ))
end

function line_element(u::ArrayPartition{F,T}, integator) where {F,T}
    (to_cartesian(integator.uprev.x[2]), to_cartesian(u.x[2]))
end

function line_element(u, integator)
    (to_cartesian(integator.uprev), to_cartesian(u))
end