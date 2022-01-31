#
# QuimpGrp: A database of QUasiprimitive, IMPrimitive permutation groups.
#
#! @Chapter Introduction
#!
#! This package, QuimpGrp, provides a database of quasiprimitive but imprimitive (quimp)
#! groups of degree at most $4095$ and some additional functions for
#! quasiprimitive groups.<P/>
#! In her 1993 paper <Cite Key="Praeger_Quasi"/>, Cheryl Praeger classified
#! all quasiprimitive permutation groups in a theorem similar to the
#! O'Nan-Scott-Theorem for primitive groups. In 
#! <Cite Key="Praeger_Baddeley"/>, Praeger and Baddeley then divide the
#! quasiprimitive groups into seven types:
#! HA, AS, TW, HS, HC, PA, SD, CD.
#! In this package, we use the notation for the Praeger-O'Nan-Scott-types
#! as give in <Cite Key="Praeger_Baddeley"/>.
#! We provide access methods for the library of quimp groups as well as
#! some additional functionality for quasiprimitive groups as described
#! below.<P/>
#! We guarantee that all groups in this library are quimp on their
#! moved points.
#!
#! @Chapter Installation
#! 
#! Due to the size of the library, the quimp groups are packaged in 4 files
#! called QUIMPN.tar.bz2, where N=1,2,3,4,5 and they can be found in the main 
#! folder of this package. Using for example tar -xf QUIMP1.tar.bz2 unpacks
#! the groups compressed in QUIMP1.tar.bz2 into the subfolder lib/.
#! Please unpack all five .tar.bz2-folders before using the library.
#! 

#!
#! @Chapter Functionality
#!
#!
#! @Section Funcitions for quasiprimitive groups
#!
#! This section describes some functions for quasiprimitive groups.

#! @Description 
#! 	This is the info class for the package QuimpGrp
DeclareInfoClass("InfoQuimpGrp");

#! @Arguments G
#! @Returns True or false
#! @Description This function tests if the permutation group <A>G</A> is quasiprimitive on its
#! moved points by testing the definition, i.e. if all non-trivial minimal normal subgroups
#! of <A>G</A> are transitive.
#! If <A>G</A> acts quasiprimitively on
#! $\Omega$, this function returns true and false otherwise.<P/>
#! Let $\Omega$ denote the moved points of <A>G</A>. Then <A>G</A> is
#! called quasiprimitive on $\Omega$ if all minimal normal subgroups of
#! <A>G</A> act transitively on $\Omega$.
DeclareProperty("IsQuasiprimitive", IsPermGroup);

#! @Arguments G
#! @Returns True or false
#! @Description This function tests if the permutation group <A>G</A> is quimp
#! (quasiprimitive but imprimitive) on its moved points by
#! testing the definition, i.e. if all minimal normal subgroups of <A>G</A>
#! are
#! transitive and the group acts imprimitively and returns true in this
#! case and false otherwise. See also <Ref Prop="IsQuasiprimitive"/>
#! for more details on quasiprimitivity.
DeclareProperty("IsQuimp", IsPermGroup);

#! @Arguments G
#! @Returns String or fail
#! @Description This function takes as input a permutation group <A>G</A>
#! and returns the Praeger-ONan-Scott type of the
#! quasiprimitive permutation group <A>G</A> as a string or fail if <A>G</A> is not
#! quasiprimitive on its moved points.<P/> In her 1993 paper
#! <Cite Key="Praeger_Quasi"/>, Cheryl Praeger classified the
#! quasiprimitive permutation groups in a theorem similar to the
#! O'Nan-Scott-Theorem for primitive groups. In 
#! <Cite Key="Praeger_Baddeley"/>, Praeger and Baddeley then divide the
#! quasiprimitive groups into seven types:
#! HA, AS, TW, HS, HC, PA, SD, CD.
#! Currently this function is only implemented for group of degree less than 216000.
DeclareAttribute("PraegerONanScottType", IsPermGroup);

DeclareSynonym( "QuasiprimitiveONanScottType", PraegerONanScottType);

#! @Section Database functions
#!
#! This section describes some functions to access the database of quimp groups.

#! @Arguments deg
#! @Returns Integer or fail
#! @Description This function returns the number of quimp groups of the
#! degree equal to <A>deg</A>, if the input is a natural number between 5 and 4095
#! and fail otherwise
DeclareGlobalFunction("NrQuimpGroups");

#! @Arguments G
#! @Returns A record or and error
#! @Description This function returns  the  socle type of the
#! quasiprimitive permutation group <A>G</A> or an error if <A>G</A> is not
#! quasiprimitive on its moved points. The socle of a quasiprimitive group is a direct product of
#! isomorphic simple groups, therefore   the  type  is indicated by a record
#! with components series, parameter (both as described under
#! <Ref BookName="Reference" Func="IsomorphismTypeInfoFiniteSimpleGroup" /> ), and
#! width for the number of  direct simple socle factors.
DeclareAttribute( "SocleTypeQuasiprimitiveGroup", IsPermGroup);

#! @Arguments arg
#! @Returns A list of quimp (quasiprimitive but imprimitive) groups.
#! @Description This function, when called with no arguments, returns a
#! list of all quasiprimitive but imprimitive (quimp) groups of degree at
#! most $4095$. In order to restrict this list to certain quimp groups only,
#! a suitable list <A>arg</A> has to be passed as an argument. The list
#! <A>arg</A> consists of an arbitrary number of pairs. A group $G$ from
#! the database passes a pair $[f,\text{val}]$ if $f(G)\in \text{val}$. The function
#! <Ref Func="AllQuimpGroups"/> returns all groups $G$ from the database of
#! quimp groups that passs every pair.
#! For more information, also see the documentation of
#! <Ref BookName="Reference" Func="AllLibraryGroups"/>.
DeclareGlobalFunction( "AllQuimpGroups" );

#! @Arguments arg
#! @Returns One quimp group
#! @Description This function calls <Ref Func="AllQuimpGroups" /> with the
#! input <A>arg</A> and returns the first group in the result of <F>AllQuimpGroups</F>(<A>arg</A>).
DeclareGlobalFunction("OneQuimpGroup");

#! @Arguments deg, nr
#! @Returns A permutation group of fail
#! @Description Returns the quimp group of degree <A>deg</A> and number
#! <A>nr</A> or fail if no such group exists.
DeclareGlobalFunction("QuimpGroup");

DeclareGlobalFunction("QuimpIdentification");