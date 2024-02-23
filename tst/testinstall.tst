gap> START_TEST("testinstall.tst");

#
gap> G := Group([ (1,14,12,11)(2,3,9,10)(4,8)(5,7,6,13), (1,13)(2,9)(3,7)(4,14)(5,8)(10,12) ]);;
gap> PraegerONanScottType(G);
"AS"

#
gap> H := Group( [ ( 1,36,61, 5,51, 4)( 2,29,56, 7,35,32)( 3,30,58,18,64,67)( 6,60,31,40,68,33)( 8,15,62,65,23,13)( 9,69,66,24,43,71)(10,39,53,37,12,59)(11,16,22,49,46,41)(14,52,34,45,42,63)(17,44,55,26,19,28)(20,25,48,70,54,21)(27,47,50,57,72,38), ( 1,72,34,12,68,47,63,46,62,42,19,18,58, 2,45)( 3,67,69,48,16,59,25,57,65,53,54, 5,40,70,44)( 4,71,14,27,32,64,43,36,20,17,50, 8,13,31,49)( 6,15,61,11,35,21,39, 9,30, 7,22,52,26,37,60)(10,24,55)(23,29,51)(28,38,56)(33,66,41) ] );;
gap> DerivedSubgroup(H) = Socle(H);
true
gap> PraegerONanScottType(H);
"PA"
gap> SocleTypeQuasiprimitiveGroup(H).parameter;
5
gap> SocleTypeQuasiprimitiveGroup(H).width;    
2
gap> SocleTypeQuasiprimitiveGroup(H).series;
"A"

#
gap> G:=Group([ (1,2,3)(4,6,8)(5,7,9)(10,11,12), (1,3,5)(2,4,6)(7,9,11)(8,10,12) ]);;
gap> SocleTypeQuasiprimitiveGroup(G).parameter;
5
gap> SocleTypeQuasiprimitiveGroup(G).series;   
"A"
gap> SocleTypeQuasiprimitiveGroup(G).width; 
1

#
gap> ForAll([1..1023], n -> NrQuimpGroups(n) = Length(AllQuimpGroups(NrMovedPoints,n)));
true
gap> ForAll([1024..2047], n -> NrQuimpGroups(n) = Length(AllQuimpGroups(NrMovedPoints,n)));
true
gap> ForAll([2048..3071], n -> NrQuimpGroups(n) = Length(AllQuimpGroups(NrMovedPoints,n)));
true
gap> ForAll([3072..4095], n -> NrQuimpGroups(n) = Length(AllQuimpGroups(NrMovedPoints,n)));
true

# valide some random database entries
gap> for n in List([1..10], i->Random(QUIMP_DEGREES)) do
>      k := Random([1..NrQuimpGroups(n)]);
>      G := QuimpGroup(n,k);
>      if MovedPoints(G) <> [1..n] then Error([n,k], ": wrong domain"); fi;
>      if AllQuimpGroups(NrMovedPoints,n)[k] <> G then Error([n,k], ": AllQuimpGroups and QuimpGroup disagree"); fi;
>      if not IsQuimp(G) then Error([n,k], ": not a quimp"); fi;
>    od;

#
gap> STOP_TEST("testinstall.tst");
