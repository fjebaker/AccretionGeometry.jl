
struct MeshAccretionGeometry{T,M} <: AbstractAccretionGeometry{T}
    mesh::GeometryBasics.Mesh{3, T, M}
    x_extent::Tuple{T,T}
    y_extent::Tuple{T,T}
    z_extent::Tuple{T,T}
end

function MeshAccretionGeometry(mesh)
    MeshAccretionGeometry(mesh, bounding_box(mesh)...)
end

# naive implementation
function bounding_box(mesh::GeometryBasics.Mesh{3, T}) where {T}
    xmin = typemax(T) ; xmax = -typemax(T)
    ymin = typemax(T) ; ymax = -typemax(T)
    zmin = typemax(T) ; zmax = -typemax(T)
    for t in mesh
        for p in t
            let x = p[1], y = p[2], z = p[3]
                (x > xmax) && (xmax = x)
                (x < xmin) && (xmin = x)
                (y > ymax) && (ymax = y)
                (y < ymin) && (ymin = y)
                (z > zmax) && (zmax = z)
                (z < zmin) && (zmin = z)
            end
        end
    end
    (xmin, xmax), (ymin, ymax), (zmin, zmax)
end