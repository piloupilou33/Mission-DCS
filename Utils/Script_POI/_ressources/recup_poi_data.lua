-- Recuperation "POI DATA"
--------------------------------------------

-- PARAMETERS 
--------------------------------------------

TABLE_CSV		= {}
THEATRE 		= env.mission.theatre

CSV_fileName 	= "SitesSAM_Datas"	
CSV_fdir_file 	= "Save_"..THEATRE.."_"..CSV_fileName ..".csv"
CSV_entetes 	= {}


-- FUNCTIONS 
--------------------------------------------
function CSVwrite(path, data, sep)
    sep = sep or ','
    local file,err = assert(io.open(path, "w"))
	if err then return err end
    for i=1,#data do
        for j=1,#data[i] do
            if j>1 then file:write(sep) end
            file:write(data[i][j])
        end
        file:write('\n')
    end
    file:close()
end

function CSV_Init_file ()
	local CSV_entetes = {"Name", "Lat", "Long", "Radius", "Coalition""}
	table.insert(TABLE_CSV, CSV_entetes)
	CSVwrite(CSV_fdir_file, TABLE_CSV)
	
end

function SAVE_CSV ()
	local updated_Date = os.date( "%Y-%m-%d %H-%M-%S" )
	CSVwrite(CSV_fdir_file, TABLE_CSV)
end


function FNC_CSV_SITESAM ( ZONE )

		local CSV_Zone_Name			= ZONE:GetName()
		local CSV_Zone_Radius		= ZONE:GetRadius()
		local CSV_Zone_Coordinate 	= ZONE:GetCoordinate()
		local CSV_Zone_lat,CSV_Zone_long = CSV_Zone_Coordinate:GetLLDDM()
		
			table.insert ( TABLE_CSV , { 	["Name"] 		= CSV_Zone_Name, 
					["Lat"] 		= CSV_Zone_lat, 
					["Long"] 		= CSV_Zone_long,
					["Radius"] 		= CSV_Zone_Radius, 
					["Coalition"] 	= "Neutral",
				})
		
		SAVE_CSV ()
	end	

	
-- RUN 
--------------------------------------------
CSV_Init_file ()

LIST_SITESAM 	= SET_ZONE:New():FilterPrefixes("SAMSITE"):FilterOnce()
LIST_SITESAM:ForEachZone( FNC_CSV_SITESAM )