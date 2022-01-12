
function intersects_geometry(m::MeshAccretionGeometry{T}, line_element) where {T}
    if in_bounding_box(m, line_element)
        #return has_intersect(m, line_element)
        true
    end
    false
end 

function in_bounding_box(m::MeshAccretionGeometry{T}, line_element) where {T}
    p = line_element[2]
    @inbounds m.x_extent[1] < p[2] < m.x_extent[2] && m.y_extent[1] < p[3] < m.y_extent[2] && m.z_extent[1] < p[4] < m.z_extent[2]
end 

function has_intersect(m::MeshAccretionGeometry{T}, line_element) where {T}
    any(triangle -> jsr_algorithm(triangle[1], triangle[2], triangle[3], line_element...), m)
end

# Jiménez, Segura, Feito. Computation Geometry 43 (2010) 474-492
function jsr_algorithm(V₁, V₂, V₃, Q₁, Q₂; ϵ=1e-6)
    A = Q₁ .- V₃
    B = V₁ .- V₃
    C = V₂ .- V₃
    W₁ = B × C
    w = A ⋅ W₁
    if w > ϵ
        D = Q₂ .- V₃
        s = D ⋅ W₁
        s > ϵ && return false
        W₂ = A × D
        t = W₂ ⋅ C
        t < -ϵ && return false
        u = -W₂ ⋅ B
        u < -ϵ && return false
        w < s + t + u && return false
    elseif w < -ϵ
        return false
    else # w == 0
        D = Q₂ .- V₃
        s = D ⋅ W₁
        if s > ϵ
            return false
        elseif s < -ϵ
            W₂ = D × A
            t = W₂ ⋅ C
            t > ϵ && return false
            u = - W₂ ⋅ B
            u > ϵ && return false
            -s > t + u && return false
        else
            return false
        end
    end
    true
end