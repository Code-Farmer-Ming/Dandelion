class CreateGetDistanceFunction < ActiveRecord::Migration
  def self.up

    execute  <<BLOCK


    CREATE  FUNCTION  MyDistance(lat1 DOUBLE, lng1 DOUBLE, lat2 DOUBLE, lng2 DOUBLE) RETURNS   DOUBLE
    BEGIN
        DECLARE  distance  DOUBLE;
        SET distance= 2 * 6378.137* ASIN(SQRT(POW(SIN(PI() * (lat1-lat2) / 360), 2) + COS(PI() * lat1 / 180)* COS(lat2* PI() / 180) * POW(SIN(PI() * (lng1-lng2) / 360), 2)));
        RETURN distance;
    END;
 
BLOCK
    
  end

  def self.down
    execute " drop function  IF EXISTS MyDistance;"
  end
end
