\pset tuples_only on

\set hexagon '\'880326b885fffff\'::h3index'
\set neighbor '\'880326b887fffff\'::h3index'
\set pentagon '\'831c00fffffffff\'::h3index'
\set uniedge '\'1180326b885fffff\'::h3index'

--
-- TEST h3_h3_indexes_are_neighbors
--

SELECT h3_h3_indexes_are_neighbors(:hexagon, :neighbor);
SELECT NOT h3_h3_indexes_are_neighbors(:hexagon, :hexagon);

--
-- TEST h3_get_h3_unidirectional_edge
--

SELECT h3_get_h3_unidirectional_edge(:hexagon, :neighbor) = :uniedge;

--
-- TEST h3_h3_unidirectional_edge_is_valid
--

SELECT h3_h3_unidirectional_edge_is_valid(:uniedge);
SELECT NOT h3_h3_unidirectional_edge_is_valid(:hexagon);

--
-- TEST h3_get_origin_h3_index_from_unidirectional_edge and
--      h3_get_destination_h3_index_from_unidirectional_edge
--

SELECT h3_get_origin_h3_index_from_unidirectional_edge(:uniedge) = :hexagon
AND h3_get_destination_h3_index_from_unidirectional_edge(:uniedge) = :neighbor;

--
-- TEST h3_get_h3_indexes_from_unidirectional_edge
--

SELECT h3_get_h3_indexes_from_unidirectional_edge(:uniedge) = (:hexagon, :neighbor);

--
-- TEST h3_get_h3_unidirectional_edges_from_hexagon
--

SELECT array_length(array_agg(edge), 1) = 6 FROM (
	SELECT h3_get_h3_unidirectional_edges_from_hexagon(:hexagon) edge
) q;
SELECT array_length(array_agg(edge), 1) = 5 expected FROM (
	SELECT h3_get_h3_unidirectional_edges_from_hexagon(:pentagon) edge
) q;

--
-- TEST h3_get_unidirectional_edge_boundary
--

SELECT h3_get_unidirectional_edge_boundary(:uniedge)
	~= polygon '((89.5830164946548,64.7146398954916),(89.5790678021742,64.2872231517217))'