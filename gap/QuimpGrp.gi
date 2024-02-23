#
# QuimpGrp: A database of QUasiprimitive, IMPrimitive permutation groups.
#
# Implementations
#

InstallMethod( IsQuasiprimitive, "for permutation groups", true,
	[IsPermGroup], 0, function(G)
	local N, normals, omega;
	if IsPrimitive(G) then 
		return true;
	elif not IsTransitive(G) then
	    return false;
	fi; 
    normals := NormalSubgroups( G );
    omega := MovedPoints(G);
    return ForAll(normals, N -> IsTrivial(N) or IsTransitive(N, omega));
end
);



InstallMethod( IsQuimp, "for permutation groups",
	[IsPermGroup],
	G -> not IsPrimitive(G) and IsQuasiprimitive(G)
);


InstallMethod( PraegerONanScottType, "for permutation groups", true,
	[IsPermGroup], 0, function(G)
local soc, Omega;
soc := Socle(G);
Omega := MovedPoints(G);
if not IsQuasiprimitive( G ) then 
    Print("<G> is not quasiprimitive on its moved points.");
	return fail;
fi;
#We use the decision tree Fig. 7.1 from Praeger,Schneider
if IsRegular( soc, Omega) then #Left part of decision tree
    if IsAbelian( soc ) then 
        return "HA";
    else #soc non-abelian
        if IsTrivial( Centraliser( G, soc )) then 
            if IsSimple( soc ) then 
				#Also known as AS_reg
                return "AS";
            else 
                return "TW";
            fi;
        else #C_G(soc) not trivial
            if IsSimple( soc ) then 
                return "HS";
            else 
                return "HC";
            fi;
        fi;
    fi;
else 
    #Right part of decision tree
    #Here we have to test if Stab_soc(om) is subdirect in 
    #soc, but this is expensive. Also, if it were than G would have degree
    #at least 60^3=216000 as it is then quimp of SD or CD type
    if NrMovedPoints( G) >= 216000 then 
        ErrorNoReturn("This case has not yet been implemented.\n");
    else 
        if IsSimple( soc ) then 
            return "AS";
        else 
            return "PA";
        fi;
    fi;
fi;
ErrorNoReturn("This should not have happened.");
end
);

#This function is constructed as SocleTypePrimitiveGroup
InstallMethod( SocleTypeQuasiprimitiveGroup, "quasiprimitive permgroups", true, 
[IsPermGroup], 0, function( G )
local soc, cs, T, id, data;
	if IsPrimitive( G ) then 
		Info(InfoQuimpGrp, 1, "<G> is primitive.");
		return SocleTypePrimitiveGroup(G);
	elif not IsQuasiprimitive( G ) then
		ErrorNoReturn( "<G> is not quasiprimitive.");
	else
		#The socle of G is a direct product of isomorphic simple groups.
		soc := Socle(G);
		cs := CompositionSeries( Socle(G));
		#One simple socle factor of soc.
		T := cs[ Length(cs)-1];
		id := IsomorphismTypeInfoFiniteSimpleGroup(T);
		data := rec(
			series := id.series,
			width := Length(cs)-1,
			name := id.name
		);
		if IsBound( id.parameter ) then 
			data.parameter := id.parameter;
		else 
			data.parameter := id.name;
		fi;
	fi;
	SetSocleTypeQuasiprimitiveGroup( G, data);
	return data;
end
);


BindGlobal("QUIMP_DATA_DIR", DirectoriesPackageLibrary( "QuimpGrp", "lib" )[1]);
Read(Filename(QUIMP_DATA_DIR,"metadata.g"));

InstallGlobalFunction(NrQuimpGroups, function(deg)
if deg <5 or deg >4095 then 
	ErrorNoReturn("Quimp groups are only known for degree between 5 and 4095.");
elif not deg in QUIMP_DEGREES then 
	return 0;
else 
	if not IsBoundGlobal( Concatenation("QUIMP_", String(deg))) then 
		Read( Filename( QUIMP_DATA_DIR,Concatenation("QUIMP_", String(deg), ".g" )));
	fi;
	return Length( EvalString( Concatenation( "QUIMP_", String(deg) ) ) );
fi;
end
);

InstallGlobalFunction( AllQuimpGroups, function(arg)
local deg, deg_list, quimps_with_property, selector, selector_value, i, G_list, data, options;
	#Check if this function was called from OneQuimpGroup:
	if Length( arg ) = 2 and arg[2] = "FromOneQuimpGroup" then 
		options := arg[1];
	else 
		options := arg;
	fi; 
	if not IsList( options ) or not IsEvenInt( Length( options ) ) then 
		Error("Wrong input.");
	fi;
	if not NrMovedPoints in options then 
		Info(InfoQuimpGrp,1, "No degree restriction given, loading all groups.");
		for deg in QUIMP_DEGREES do 
			if not IsBoundGlobal( Concatenation("QUIMP_", String(deg) ) ) then 
				Read( Filename( QUIMP_DATA_DIR,Concatenation("QUIMP_", String(deg), ".g" )));
			fi;
		od;	
	deg_list := QUIMP_DEGREES;
	else
		if IsList( options[Position(options, NrMovedPoints) +1] ) then 
			deg_list := options[ Position( options, NrMovedPoints)+1];
		else 
			deg_list := [options[ Position( options, NrMovedPoints)+1]];
		fi;
		#Remove degrees where no quimp group exists
		if ForAny( deg_list, deg -> deg<5 or deg >4095) then 
			ErrorNoReturn("Quimp groups are only available with degree between 5 and 4095.");
		fi;
		deg_list := Filtered( deg_list, deg -> deg in QUIMP_DEGREES);
		for deg in deg_list do 
			if not IsBoundGlobal( Concatenation("QUIMP_", String(deg) ) ) then 
				Read( Filename( QUIMP_DATA_DIR,Concatenation("QUIMP_", String(deg), ".g" )));
			fi;
		od;
	fi;
	quimps_with_property := [];
	for deg in deg_list do 
		for G_list in EvalString( Concatenation("QUIMP_", String(deg))) do
			Add( quimps_with_property, G_list);
		od;
	od;
	#No more filters to apply, so return all groups with degree in deg_list
	if Length( options ) = 2 and options[1]=NrMovedPoints  then 
		for G_list in quimps_with_property do 
			SetPraegerONanScottType( G_list[1], G_list[2]);
			SetSocle(G_list[1], G_list[3]);
			data := G_list[5];
			data.width := G_list[6];
			SetSocleTypeQuasiprimitiveGroup( G_list[1], data);
		od;
		return List(quimps_with_property, G_list -> G_list[1]);
	fi;
	#First we check for presaved properties
	if PraegerONanScottType in options then 
		selector_value := options[ Position( options, PraegerONanScottType) +1 ];
		if not IsString( selector_value ) then 
			ErrorNoReturn("The value for PraegerONanScottType must be a string.\n");
		elif not selector_value in ["HA", "HS", "HC", "TW", "PA", "CD", "AS"] then 
			ErrorNoReturn("The type you are asking for does not exist.");
		fi;
		quimps_with_property :=  Filtered( quimps_with_property, G_list -> G_list[2]= selector_value);
	fi;
	if SocleTypeQuasiprimitiveGroup in options then 
		selector_value := options[Position( options, SocleTypeQuasiprimitiveGroup) +1];
		if not IsRecord( selector_value ) then 
			ErrorNoReturn("Value of SocleTypeQuasiprimitiveGroup must be a record");
		elif 
			not IsBound( selector_value.name) then 
		fi;
		#First select groups whose simple socle factor name matches:
		quimps_with_property := Filtered( quimps_with_property, G_list -> G_list[5].name = selector_value.name);
		#Now check for number of minimal normal subgroups
		if IsBound( selector_value.width ) then 
			quimps_with_property := Filtered( quimps_with_property, G_list -> G_list[6] = selector_value.width);
		fi;
	fi;
	#Now check properties not prestored.
	for i in Filtered( [1..Size(options)], IsOddInt) do 
		#We already selected groups according to the filters below
		if not options[i] in [PraegerONanScottType, QuasiprimitiveONanScottType, SocleTypeQuasiprimitiveGroup] then 
			if IsList( options[i+1] ) then 
				quimps_with_property := Filtered( quimps_with_property, G_list -> options[i](G_list[1]) in options[i+1] );
			else 
				quimps_with_property := Filtered( quimps_with_property, G_list -> options[i](G_list[1]) = options[i+1] );
			fi;
		fi;
	od;
	for G_list in quimps_with_property do 
		SetPraegerONanScottType( G_list[1], G_list[2]);
		SetSocle(G_list[1], G_list[3]);
		data := G_list[5];
		data.width := G_list[6];
		SetSocleTypeQuasiprimitiveGroup( G_list[1], data);
	od;
	return List(quimps_with_property, G_list -> G_list[1]);
end
);

InstallGlobalFunction( OneQuimpGroup, function(arg)
local res,i;
	res := AllQuimpGroups( arg, "FromOneQuimpGroup" );
	if IsEmpty( res ) then 
		return [ ];
	else 
		return res[1];
	fi;
end
);

InstallGlobalFunction(QuimpGroup, function( deg, nr)
	local name, G_list, data;
	if not IsInt(deg) or not IsInt(nr) then 
		ErrorNoReturn("<deg> and <nr> must be integers.");
	elif deg<5 or deg > 4095 then 
		ErrorNoReturn("Quimp groups are only available with degree between 5 and 4095.");
	elif not deg in QUIMP_DEGREES then 
		ErrorNoReturn("There is no quimp group of degree <deg>=", deg, ".");
	fi;
	#We can assume there exists a quimp group of degree deg.
	name := Concatenation("QUIMP_", String(deg));
	if not IsBoundGlobal(name ) then 
		Read( Filename( QUIMP_DATA_DIR, Concatenation(name, ".g") ) );
	fi;
	if nr > Size( EvalString(name) ) then 
		ErrorNoReturn("There are only ", Size( EvalString(name) ), " quimp groups of degree ", deg, ".");
	fi;
	G_list := EvalString(name)[nr];
	SetPraegerONanScottType( G_list[1], G_list[2]);
	SetSocle(G_list[1], G_list[3]);
	data := G_list[5];
	data.width := G_list[6];
	SetSocleTypeQuasiprimitiveGroup( G_list[1], data);
	return G_list[1];
end
);

#This is not done yet. Don't test, don't review
InstallGlobalFunction(QuimpIdentification, function(G)
local cands, H, suborbits, omega, soc_quot, invariants, factors, sylow_orbs_G, sylow_orbs_H, i,j,q, ag, series_ag, series_H,
 PGICS, bg,a,b, alpha, beta, N, S, CS, deg;
if not IsQuimp(G) then 
	ErrorNoReturn("<G> is not quimp on its moved points.");
fi;
deg := NrMovedPoints(G);
#Do a first filter:
cands := AllQuimpGroups( NrMovedPoints, deg, PraegerONanScottType, PraegerONanScottType(G), Size, Size(G) );
#Done if Size(cands)=1
if Size(cands) = 1 then 
	return [deg, Position( AllQuimpGroups(NrMovedPoints,NrMovedPoints(G)), cands[1])];
fi;
if PraegerONanScottType(G) = "AS" then 
	cands := Filtered(cands, H-> IsSimple(H)=IsSimple(G));
	if Size(cands)=1 then 
		return [deg,Position( AllQuimpGroups(NrMovedPoints,NrMovedPoints(G)), cands[1])];
	fi;
fi;
omega := MovedPoints(G);
#Check compatibility of blocks
cands := Filtered( cands, H-> Size(RepresentativesMinimalBlocks( H, MovedPoints(H)) ) = 
	Size(RepresentativesMinimalBlocks(G, omega) ) and ForAll( RepresentativesMinimalBlocks( H, MovedPoints(H)),
	 block -> Size(block) in List(RepresentativesMinimalBlocks(G, omega), Size)	 ) );
if Size(cands)=1 then 
	return [deg,Position( AllQuimpGroups(NrMovedPoints,NrMovedPoints(G)), cands[1])];
fi;
cands := Filtered( cands, H-> SocleTypeQuasiprimitiveGroup(H) = SocleTypeQuasiprimitiveGroup(G));
if Size(cands)=1 then 
	return [deg,Position( AllQuimpGroups(NrMovedPoints,NrMovedPoints(G)), cands[1])];
fi;
#Check length of suborbits
suborbits := Orbits( Stabiliser( G, omega[1]));
cands := Filtered( cands, H-> Size(Orbits( Stabiliser(H,1) )) = Size(suborbits)  and 
	ForAll( Orbits(Stabiliser(H,1) ), orb -> Size(orb) in List(suborbits, Size)  ) );
if Size(cands) = 1 then 
	return [deg,Position( AllQuimpGroups(NrMovedPoints,NrMovedPoints(G)), cands[1])];
fi;
#Check abelian invariants
invariants := AbelianInvariants(G);
cands := Filtered( cands, H-> AbelianInvariants(H)=invariants);
if Size(cands)=1 then 
	return [deg,Position( AllQuimpGroups(NrMovedPoints,NrMovedPoints(G)), cands[1])];
fi;
#Sylow-orbits
factors := Reversed( Set( Factors( Size(G))));
#Run through sylow subgroups, test for sylow orbits and then remove them
while Length( cands ) > 1 and Length( factors ) > 0 do
	sylow_orbs_G := Collected( List( Orbits( SylowSubgroup(G, factors[1]), MovedPoints(G) ), Length ) );
	sylow_orbs_H := [];
	for i in [1..Length(cands)] do 
		sylow_orbs_H[i] := Collected( List( Orbits( SylowSubgroup(cands[i],factors[1]), MovedPoints(cands[i]) ),Length ) );
	od;
	#Remove groups whose sylow orbit length don't match
	cands := cands{Filtered([1..Length(cands)], i-> sylow_orbs_H[i]=sylow_orbs_G )};
	factors := factors{[2..Length(factors)]};
od;
if Length(cands) = 1 then 
	return [deg,Position( AllQuimpGroups(NrMovedPoints,NrMovedPoints(G)), cands[1])];
fi;
#Use more Sylow tests:
for q in Set( Factors( Size(G)/Size(Socle(G)))) do 
	if q=1 then 
		q := 2;
	fi;
	ag := Image( IsomorphismPcGroup( SylowSubgroup(G, q)));
	#Central series
	series_ag := List( LowerCentralSeries( ag), Size);
	series_H := [];
	for i in [1..Length(cands)] do 
		series_H[i] := List( LowerCentralSeries(Image( IsomorphismPcGroup(SylowSubgroup(cands[i],q)))), Size);
	od;
	cands := cands{Filtered( [1..Length(cands)], i-> series_H[i]=series_ag) };
	if Size(cands)=1 then 
		return [deg,Position( AllQuimpGroups(NrMovedPoints,NrMovedPoints(G)), cands[1])];
	fi;
	#Frattini
	a := Size( FrattiniSubgroup(ag));
	b := [];
	for i in [1..Length(cands)] do 
		bg := Image( IsomorphismPcGroup( SylowSubgroup(cands[i],q)));
		b[i] := Size(FrattiniSubgroup(bg));
	od;
	cands := cands{Filtered( [1..Length(cands)], i-> b[i]=a ) };
	if Size(cands)=1 then 
		return [deg,Position( AllQuimpGroups(NrMovedPoints,NrMovedPoints(G)), cands[1])];
	fi;
	#Sylow 2 subgroup
	if Size(ag) < 512 then
		a := IdGroup(ag);
		b := [];
		for i in [1..Length(cands)] do 
			bg := Image( IsomorphismPcGroup( SylowSubgroup(cands[i],q)));
			b[i] := IdGroup(bg);
		od;
		cands := cands{Filtered( [1..Length(cands)], i-> b[i]=a ) };
		if Size(cands)=1 then 	
			return [deg,Position( AllQuimpGroups(NrMovedPoints,NrMovedPoints(G)), cands[1])];
		fi;
	fi;
od;
if Size(cands)=1 then 
	return [deg,Position( AllQuimpGroups(NrMovedPoints,NrMovedPoints(G)), cands[1])];
fi;
#Special tests for PA case before computing classes
if PraegerONanScottType(G)="PA" then 
	#Check socle quotient
	soc_quot := FactorGroup( G, Socle(G));
	cands := Filtered( cands, H-> IdGroup( FactorGroup( H, Socle(H) ) ) = IdGroup(soc_quot) );
	if Size(cands) = 1 then 
		return [deg,Position( AllQuimpGroups(NrMovedPoints,NrMovedPoints(G)), cands[1])];
	fi;
	#Action of the socle quotients on socle factors
	CS := CompositionSeries( Socle(G));
	CS := CS[Length( CS )-1 ];
	N := Normalizer( G, CS);
	beta := FactorCosetAction(G,N);
	alpha := FactorCosetAction( N, ClosureGroup( Centraliser(G,CS), Socle(G)));
	a := TransitiveIdentification( Group( KuKGenerators(G, beta,alpha)));
	b := [];
	for i in [1..Length(cands)] do
		S := Socle( cands[i]);
		CS := CompositionSeries(S);
		CS := CS[Length(CS)-1];
		N := Normalizer( cands[i],CS);
		beta := FactorCosetAction( cands[i], N);
		alpha := FactorCosetAction( N, ClosureGroup( Centraliser(N,CS),S));
		b[i] := TransitiveIdentification( Group( KuKGenerators(cands[i],beta,alpha)));
	od;
	cands := cands{Filtered( [1..Length(cands)], i-> b[i]=a ) };
	if Size(cands) =1 then 
		return [deg,Position( AllQuimpGroups(NrMovedPoints,NrMovedPoints(G)), cands[1])];
	fi;
fi;
#Classes:
a:=Collected(List(ConjugacyClasses(G:onlysizes),i->[CycleStructurePerm(Representative(i)),Size(i)]));
b := [];
for i in [1..Length(cands)] do
		b[i] := Collected(List(ConjugacyClasses(cands[i]:onlysizes),
			j->[CycleStructurePerm(Representative(j)),Size(j)]));
od;
cands := cands{Filtered( [1..Length(cands)], i-> b[i]=a ) };
if Size(cands)=1 then 
	return [deg,Position( AllQuimpGroups(NrMovedPoints,NrMovedPoints(G)), cands[1])];
fi;


#Now special tests depending on the type:

if PraegerONanScottType(G)="TW" then 
	Error("TODO");
fi;

return List( cands, G-> [deg,Position(AllQuimpGroups(NrMovedPoints,NrMovedPoints(G)),G ) ]);
end
);