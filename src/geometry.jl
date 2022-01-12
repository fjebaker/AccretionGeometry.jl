abstract type AbstractAccretionGeometry{T} end
abstract type AbstractAccretionDisc{T} <: AbstractAccretionGeometry{T} end

function to_cartesian(vec::StaticVector{S,T}) where {S,T}
    SVector{S,T}(vec[1], to_cartesian(vec[2], vec[3], vec[4]))
end

function to_cartesian(vec::AbstractVector{T}) where {T}
    cart_vec = copy(vec)
    cart_vec[2:4] .= to_cartesian(vec[2], vec[3], vec[4])
    cart_vec
end

function to_cartesian(r, θ, ϕ)
    sinϕ = sin(ϕ)
    (r * sinϕ * cos(θ), r * sinϕ * sin(θ), r * cos(ϕ))
end

function line_element(u, integator) 
    (to_cartesian(integator.uprev), to_cartesian(u))
end