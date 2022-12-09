DROP DATABASE if exists platforms;
CREATE DATABASE platforms;

USE platforms;

DROP TABLE IF EXISTS global;
CREATE TABLE global (
Indexs  INTEGER Primary key,
Type  VARCHAR(255),
Title  VARCHAR(255),
Director   VARCHAR(1200),
Cast      VARCHAR(1200),
Country    VARCHAR(255),
Date_added   VARCHAR(255),
Release_year  INTEGER,
Rating    VARCHAR(255),
Duration   TEXT,
Listed_in  VARCHAR(255),
Description VARCHAR(2000),
Platform  VARCHAR(255)
) ENGINE=InnoDB CHARSET=utf8 COLLATE=utf8_unicode_ci;
LOAD DATA INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\plataformas.csv' 
INTO TABLE global
FIELDS TERMINATED BY ',' ENCLOSED BY '"' ESCAPED BY '\n' 
LINES TERMINATED BY '\r\n' IGNORE 1 LINES;


SELECT * FROM global
where Title ="Om Shanti Om";


#1 Máxima duración según tipo de film (película/serie), por plataforma y por año: El request debe ser: get_max_duration(año, plataforma, [min o season])

SET GLOBAL log_bin_trust_function_creators = 1;

DROP FUNCTION IF EXISTS maxduration;
DELIMITER //
CREATE FUNCTION maxduration(anio INTEGER, plataforma VARCHAR(255), min VARCHAR(255)) RETURNS VARCHAR(255)
BEGIN
    DECLARE pelicula VARCHAR(255);
    select 
    Title INTO pelicula
    from global
	where Release_year=anio and Platform=plataforma and Duration like concat ("%",min,"%") 
	order by CONVERT(SUBSTRING_INDEX(Duration,' ', 1), UNSIGNED INTEGER) desc
    LIMIT 1;
	
RETURN pelicula;
END;//

select * from global where Title like "%the house that jack built%"
order by Duration desc

select  maxduration (2018, "hulu", "min")




#2Cantidad de películas y series (separado) por plataforma El request debe ser: get_count_plataform(plataforma

DROP PROCEDURE IF EXISTS cantidad;
DELIMITER //
CREATE PROCEDURE cantidad (IN plataforma VARCHAR(255), OUT plat varchar(255), OUT valormovie INTEGER, OUT valortvshow INTEGER)
BEGIN
	SET plat = (plataforma);

	SET valormovie = (
	select count(Type) 
	from global
	where Platform = plataforma and Type="Movie");
    
    SET valortvshow = (
	select count(Type)
	from global
	where Platform = plataforma and Type="TV Show");
    
END;//

CALL cantidad("netflix",  @plat, @valormovie, @valortvshow);
SELECT @plat, @valormovie, @valortvshow;





#3 Cantidad de veces que se repite un género y plataforma con mayor frecuencia del mismo.global El request debe ser: get_listedin('genero')
#Como ejemplo de género pueden usar 'comedy', el cuál deberia devolverles un cunt de 2099 para la plataforma de amazon.


DROP PROCEDURE IF EXISTS genero;

delimiter //
create procedure genero (in genero varchar(255),out plataforma varchar(255), out cantidad int)
begin
select count(listed_in), Platform
from global
where listed_in like concat ("%",genero,"%") 
group by platform
order by count(listed_in) desc
limit 1
into cantidad, plataforma;
end//
delimiter ;

call genero("Comedy", @cantidad, @plataforma);
select @cantidad , @plataforma;

#4 Actor que más se repite según plataforma y año. El request debe ser: get_actor(plataforma, año)
DROP PROCEDURE IF EXISTS actores;

delimiter //
create procedure actores (in plataforma_search varchar(255),  in anio integer, out plataforma varchar(255),  out veces int, out actor varchar(255))
begin
	set plataforma = (plataforma_search);
    set veces = ( 
    select  count(Cast) 
	from global
	where Release_year = anio and Platform = plataforma_search
	order by count(Cast) desc
	limit 1);
    set actor = ( 
    select Cast
	from global
	where Release_year = anio and Platform = plataforma_search
	order by count(Cast) desc
	limit 1);
    
end//
delimiter ; listo

call actores("netflix",2018, @plataforma, @veces, @actor);
select  @veces, @actor, @plataforma;


select distinct Cast, count(Cast), char_length(Cast)
from global
where Release_year = 2018 and Platform = "netflix"
order by char_length(count(Cast)) desc
limit 1;


select cast
from global
where Release_year = 2018 and Platform = "netflix"
group by Cast;



CREATE PROCEDURE simple_loop (in anio integer, in plataforma varchar(255), out cantidad integer, out actor varchar(255))
BEGIN
	DECLARE counter varchar(255);
	DECLARE lista varchar(255);
    select Cast into counter
    from global
    where Release_year = 2018 and Platform = "netflix"
    my_loop: LOOP
    SET counter=counter+1;

    IF counter=10 THEN
      LEAVE my_loop;
    END IF;

    SELECT counter;

  END LOOP my_loop;
END$$
DELIMITER ;