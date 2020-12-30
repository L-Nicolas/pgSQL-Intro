
CREATE OR REPLACE FUNCTION calculer_longueur_max(varchar, varchar) RETURNS integer AS $$	
DECLARE
	long_chaine1 integer ;
	long_chaine2 integer ;
BEGIN
	long_chaine1 := length($1) ;
	long_chaine2 := length($2) ;

	RAISE INFO 'Début du calcul' ;
	
	IF long_chaine1 > long_chaine2 THEN
		RAISE NOTICE 'La chaîne de caractère 1 est la plus longue avec une taille de : %', long_chaine1;
		RETURN (long_chaine1);

	ELSIF long_chaine1 < long_chaine2 THEN
		RAISE NOTICE 'La chaîne de caractère 2 est la plus longue avec une taille de : %', long_chaine2;
		RETURN (long_chaine2);

	ELSE
		RAISE NOTICE 'Les deux chaînes ont la même longueur, qui est de : %', long_chaine1;
		RETURN (long_chaine2);

	END IF ;
END ;
$$ LANGUAGE plpgsql ;	 


DROP FUNCTION nb_occurrences;

CREATE OR REPLACE FUNCTION nb_occurrences(charactere varchar, chaine varchar, ind_debut integer, ind_fin integer) RETURNS integer AS $$	
DECLARE
	intervalle varchar;
	fin_interv integer;
	nb_occ integer;
BEGIN
	fin_interv := ind_fin - ind_debut;
	fin_interv := fin_interv + 1;
	nb_occ := 0;
	RAISE INFO 'Début du calcul' ;
	intervalle := SUBSTRING(chaine from ind_debut for fin_interv);

	FOR i IN 1..length(intervalle) + 1 LOOP
		IF SUBSTRING(intervalle from i for 1) = charactere THEN
			nb_occ = nb_occ + 1;
		END IF	;
		
	END LOOP ;
	RETURN nb_occ;
END ;
$$ LANGUAGE plpgsql ;	


DROP FUNCTION nb_occurrences_v2;

CREATE OR REPLACE FUNCTION nb_occurrences_v2(charactere varchar, chaine varchar, ind_debut integer, ind_fin integer) RETURNS integer AS $$	
DECLARE
	intervalle varchar;
	fin_interv integer;
	nb_occ integer;
	i integer;
BEGIN
	fin_interv := ind_fin - ind_debut;
	fin_interv := fin_interv + 1;
	nb_occ := 0;
	i := 0;
	RAISE INFO 'Début du calcul' ;
	intervalle := SUBSTRING(chaine from ind_debut for fin_interv);

	WHILE i <= length(intervalle) LOOP
		i = i + 1;
		IF SUBSTRING(intervalle from i for 1) = charactere THEN
			nb_occ = nb_occ + 1;
		END IF	;
		
	END LOOP ;
	RETURN nb_occ;
END ;
$$ LANGUAGE plpgsql ;


DROP FUNCTION nb_occurrences_v3;

CREATE OR REPLACE FUNCTION nb_occurrences_v3(charactere varchar, chaine varchar, ind_debut integer, ind_fin integer) RETURNS integer AS $$	
DECLARE
	intervalle varchar;
	fin_interv integer;
	nb_occ integer;
	i integer;
BEGIN
	fin_interv := ind_fin - ind_debut;
	fin_interv := fin_interv + 1;
	nb_occ := 0;
	i := 0;
	RAISE INFO 'Début du calcul' ;
	intervalle := SUBSTRING(chaine from ind_debut for fin_interv);

	  LOOP 
		EXIT WHEN i > length(intervalle);
		i = i + 1;
		IF SUBSTRING(intervalle from i for 1) = charactere THEN
			nb_occ = nb_occ + 1;
		END IF	;
		
	END LOOP ;
	RETURN nb_occ;
END ;
$$ LANGUAGE plpgsql ;


DROP FUNCTION getNbJoursParMois;

CREATE OR REPLACE FUNCTION getNbJoursParMois( datenb DATE )  RETURNS INTEGER AS $$

DECLARE
    jdansm CONSTANT INT2[12] = '{31,28,31,30,31,30,31,31,30,31,30,31}';
    MM INT2 ;
    R INT2 ;
BEGIN
    MM := EXTRACT ( MONTH FROM $1):: INTEGER ;
    R := jdansm [MM] ;
    IF ( MM=2) AND (EXTRACT(YEAR FROM $1)::INTEGER%4=0) AND ((EXTRACT(YEAR FROM $1)::INTEGER%100!=0) OR (EXTRACT(YEAR FROM $1)::INTEGER%400=0)) THEN
        R := R+1;
    END IF ;
    RETURN R;
END ;
$$ LANGUAGE plpgsql ;


DROP FUNCTION dateSqlToDatefr;

CREATE OR REPLACE FUNCTION dateSqlToDatefr(dateSql date) RETURNS varchar AS $$	
DECLARE
	datefr varchar;
BEGIN
	datefr := TO_CHAR(dateSql, 'dd/mm/yyyy') ;
	RETURN datefr;
END ;
$$ LANGUAGE plpgsql ;


DROP FUNCTION getNomJour;

CREATE OR REPLACE FUNCTION getNomJour ( dnj DATE )  RETURNS VARCHAR (9) AS $$

DECLARE
    
BEGIN
    IF EXTRACT ( DOW FROM dnj ) = 1
    THEN RETURN 'Lundi';
    ELSEIF EXTRACT ( DOW FROM dnj ) = 2
    THEN RETURN 'Mardi';
    ELSEIF EXTRACT ( DOW FROM dnj ) = 3
    THEN RETURN 'Mecredi';
    ELSEIF EXTRACT ( DOW FROM dnj ) = 4
    THEN RETURN 'Jeudi';
    ELSEIF EXTRACT ( DOW FROM dnj ) = 5
    THEN RETURN 'Vendredi';
    ELSEIF EXTRACT ( DOW FROM dnj ) = 6
    THEN RETURN 'Samedi';
    ELSEIF EXTRACT ( DOW FROM dnj ) = 0
    THEN RETURN 'Dimanche';
    END IF;
    return dnj ;
END ;
$$ LANGUAGE plpgsql ;


DROP FUNCTION nbClientDebit;

CREATE OR REPLACE FUNCTION nbClientDebit() RETURNS INTEGER AS $$
DECLARE
    resultat INTEGER ;
BEGIN
    SELECT INTO resultat count (*)  from operation where type_operation = 'DEBIT';
    return resultat ;
END ;
$$ LANGUAGE plpgsql ;


DROP FUNCTION nbClientVillefonction;

CREATE OR REPLACE FUNCTION nbClientVillefonction(ville VARCHAR(100)) RETURNS INTEGER AS $$
    DECLARE
        resultat INTEGER ;
    BEGIN
        SELECT INTO resultat COUNT(*) FROM client WHERE adresse_client LIKE CONCAT ('%' , ville , '%' ) ;
        IF NOT FOUND THEN
            resultat := 0 ; 
        END IF ;
        RETURN resultat ;
    END ;
$$ LANGUAGE plpgsql ;


DROP FUNCTION enrgNvClient;

CREATE OR REPLACE FUNCTION enrgNvClient(nom VARCHAR(30), prenom VARCHAR(30), adresse VARCHAR(192), identifiant VARCHAR(30), mdp VARCHAR(30)) RETURNS INTEGER AS $$
    DECLARE
        numMax INTEGER ;
        resultat VARCHAR ;
    BEGIN
		numMax := 1;
		SELECT INTO numMax MAX(num_client) FROM client;
		numMax := numMax + 1;
        INSERT INTO client (num_client, nom_client, prenom_client, adresse_client, identifiant_internet, mdp_internet) VALUES (numMax, nom, prenom, adresse, identifiant, mdp);
        SELECT INTO resultat * FROM client WHERE num_client = numMax ;
        RETURN resultat ;
    END ;
$$ LANGUAGE plpgsql ;




