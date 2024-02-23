gap> START_TEST("IsQuasiprimitive.tst");

# trivial group
gap> G:=Group(());;
gap> IsPrimitive(G);
true
gap> IsQuasiprimitive(G);
true
gap> IsQuimp(G);
false

# not transitive -> not quasiprimitive nor quimp
gap> G:=Group( (1,2), (3,4) );;
gap> IsPrimitive(G);
false
gap> IsQuasiprimitive(G);
false
gap> IsQuimp(G);
false

#
gap> G:=Group( (1,2,3)(4,6,8)(5,7,9)(10,11,12), (1,3,5)(2,4,6)(7,9,11)(8,10,12) );;
gap> IsPrimitive(G);
false
gap> IsQuasiprimitive(G);
true
gap> IsQuimp(G);
true

#
gap> G := Group( (1,2,3,4), (2,4) );;
gap> IsPrimitive(G);
false
gap> IsQuasiprimitive(G);
false
gap> IsQuimp(G);
false

#
gap> G := Group((1,2,3,4),(1,2));;
gap> IsPrimitive(G);
true
gap> IsQuasiprimitive(G);
true
gap> IsQuimp(G);
false

#
gap> STOP_TEST("IsQuasiprimitive.tst");
