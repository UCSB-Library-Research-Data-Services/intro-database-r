.nullvalue -NULL-

CREATE TABLE Species (
    Code VARCHAR PRIMARY KEY,
    Common_name VARCHAR UNIQUE NOT NULL,
    Scientific_name VARCHAR, -- can't make NOT NULL, missing data in some rows
    Relevance VARCHAR
);
COPY Species FROM 'species.csv' (header TRUE);

CREATE TABLE Site (
    Code VARCHAR PRIMARY KEY,
    Site_name VARCHAR UNIQUE NOT NULL,
    Location VARCHAR NOT NULL,
    Latitude FLOAT NOT NULL CHECK (Latitude BETWEEN -90 AND 90),
    Longitude FLOAT NOT NULL CHECK (Longitude BETWEEN -180 AND 180),
    Area FLOAT NOT NULL CHECK (Area > 0),
    UNIQUE (Latitude, Longitude)
);
COPY Site FROM 'site.csv' (header TRUE);

CREATE TABLE Personnel (
    Abbreviation VARCHAR PRIMARY KEY,
    Name VARCHAR UNIQUE NOT NULL
);
COPY Personnel FROM 'personnel.csv' (header TRUE);

CREATE TABLE Camp_assignment (
    Year INTEGER NOT NULL CHECK (Year BETWEEN 1950 AND 2015),
    Site VARCHAR NOT NULL,
    Observer VARCHAR NOT NULL,
    Start DATE,
    "End" DATE,
    FOREIGN KEY (Site) REFERENCES Site (Code),
    FOREIGN KEY (Observer) REFERENCES Personnel (Abbreviation),
    CHECK (Start <= "End"),
    CHECK (Start BETWEEN (Year||'-01-01')::DATE AND (Year||'-12-31')::DATE),
    CHECK ("End" BETWEEN (Year||'-01-01')::DATE AND (Year||'-12-31')::DATE)
);
COPY Camp_assignment FROM 'ASDN_Camp_assignment.csv' (header TRUE);

CREATE TABLE Bird_nests (
    Book_page VARCHAR,
    Year INTEGER NOT NULL CHECK (Year BETWEEN 1950 AND 2015),
    Site VARCHAR NOT NULL,
    Nest_ID VARCHAR PRIMARY KEY,
    Species VARCHAR NOT NULL,
    Observer VARCHAR,
    Date_found DATE NOT NULL
        CHECK (
            Date_found BETWEEN (Year||'-01-01')::DATE
            AND (Year||'-12-31')::DATE
        ),
    how_found VARCHAR CHECK (how_found IN ('searcher', 'rope', 'bander')),
    Clutch_max INTEGER CHECK (Clutch_max BETWEEN 0 AND 20),
    floatAge FLOAT CHECK (floatAge BETWEEN 0 AND 30),
    ageMethod VARCHAR CHECK (ageMethod IN ('float', 'lay', 'hatch')),
    FOREIGN KEY (Site) REFERENCES Site (Code),
    FOREIGN KEY (Species) REFERENCES Species (Code),
    FOREIGN KEY (Observer) REFERENCES Personnel (Abbreviation)
);
COPY Bird_nests FROM 'ASDN_Bird_nests.csv' (header TRUE);

CREATE TABLE Bird_eggs (
    Book_page VARCHAR,
    Year INTEGER NOT NULL CHECK (Year BETWEEN 1950 AND 2015),
    Site VARCHAR NOT NULL,
    Nest_ID VARCHAR NOT NULL,
    Egg_num INTEGER NOT NULL CHECK (Egg_num BETWEEN 1 AND 20),
    Length FLOAT NOT NULL CHECK (Length > 0 AND Length < 100),
    Width FLOAT NOT NULL CHECK (Width > 0 AND Width < 100),
    PRIMARY KEY (Nest_ID, Egg_num),
    FOREIGN KEY (Site) REFERENCES Site (Code),
    FOREIGN KEY (Nest_ID) REFERENCES Bird_nests (Nest_ID)
);
COPY Bird_eggs FROM 'ASDN_Bird_eggs.csv' (header TRUE);
