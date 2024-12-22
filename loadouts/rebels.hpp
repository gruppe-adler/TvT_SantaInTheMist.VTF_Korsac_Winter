class rebels {
    class AllUnits {
        uniform[] = {
            "rhsgref_uniform_TLA_1",
            "rhsgref_uniform_TLA_2"
        };
        vest[] = {
            "V_BandollierB_oli"
        };
        backpack[] = {
            "rhs_assault_umbts"
        };
        headgear[] = {
            "H_Shemag_olive",
            "H_ShemagOpen_tan"
        };
        goggles[] = {
            ""
        };
        primaryWeapon[] = {
            "rhs_weap_aks74u"
        };
        primaryWeaponMagazine = "rhs_30Rnd_545x39_7N6M_AK";

        binoculars = "Binocular";
        map = "ItemMap";
        compass = "ItemCompass";
        watch = "ItemWatch";
        gps = "ItemGPS";
        radio = "tfar_anprc152";
        nvgoggles = "";
        addItemsToUniform[] = {
            
            "ACE_epinephrine",
            "ACE_Flashlight_KSF1",
            "ACE_MapTools",
            "ACE_key_lockpick",
            "ACE_key_east"
        };
    };
    class Type {
        //Rifleman
        class Soldier_F {
            addItemsToVest[] = {
                LIST_3("rhs_30Rnd_545x39_7N6M_AK"),
                LIST_1("rhs_mag_rdg2_white"),
                "rhs_mag_mk84"
            };
            addItemsToBackpack[] = {
                LIST_3("rhs_30Rnd_545x39_7N6M_AK"),
                LIST_4("ACE_splint"),
                LIST_6("ACE_fieldDressing"),
                LIST_4("ACE_morphine"),
                LIST_2("ACE_splint"),
                LIST_1("ACE_salineIV"),
                "ACE_surgicalKit" 
            };
        };

        //Asst. Autorifleman
        class soldier_AAR_F: Soldier_F {
            addItemsToVest[] = {
                LIST_3("rhs_30Rnd_545x39_7N6M_AK"),
                LIST_1("rhs_mag_rdg2_white")
            };
            addItemsToBackpack[] = {
                LIST_3("rhs_30Rnd_545x39_7N6M_AK"),
                LIST_1("rhs_100Rnd_762x54mmR"),
                LIST_6("ACE_fieldDressing"),
                LIST_4("ACE_morphine"),
                LIST_2("ACE_splint"),
                LIST_1("ACE_salineIV"),
                "ACE_surgicalKit" 
            };
        };

        //Autorifleman
        class soldier_AR_F: Soldier_F {
            primaryWeapon = "rhs_weap_pkp";
            primaryWeaponMagazine = "rhs_100Rnd_762x54mmR";
            addItemsToVest[] = {
                LIST_1("rhs_100Rnd_762x54mmR")
            };
            addItemsToBackpack[] = {
                LIST_3("rhs_100Rnd_762x54mmR"),
                LIST_6("ACE_fieldDressing"),
                LIST_4("ACE_morphine"),
                LIST_2("ACE_splint"),
                LIST_1("ACE_salineIV"),
                "ACE_surgicalKit" 
            };
        };

        //Combat Life Saver
        class medic_F: Soldier_F {
            addItemsToVest[] = {
                LIST_1("rhs_30Rnd_545x39_7N6M_AK")
            };
            addItemsToBackpack[] = {
                LIST_15("ACE_fieldDressing"),
                LIST_8("ACE_morphine"),
                LIST_8("ACE_epinephrine"),
                LIST_1("ACE_salineIV_500"),
                LIST_1("ACE_salineIV_250"),
                LIST_15("ACE_splint"),
                LIST_5("rhs_30Rnd_545x39_7N6M_AK")
            };
        };

        //Rifleman (AT)
        class soldier_LAT_F: Soldier_F {
            secondaryWeapon = "rhs_weap_rpg26";
        };

        //Squad Leader
        class Soldier_SL_F: Soldier_F {
            primaryWeapon[] = {
                "rhs_weap_aks74n_gp25"
            };
            primaryWeaponUnderbarrelMagazine = "rhs_GRD40_White";
            addItemsToBackpack[] = {
                LIST_7("rhs_30Rnd_545x39_7N6M_AK"),
                LIST_2("rhs_mag_rdg2_white"),
                LIST_2("rhs_GRD40_White"),
                LIST_2("rhs_GRD40_Red"),
                LIST_6("ACE_fieldDressing"),
                LIST_4("ACE_morphine"),
                LIST_2("ACE_splint"),
                LIST_1("ACE_salineIV"),
                "ACE_surgicalKit" 
            };
        };

        //Team Leader
        class Soldier_TL_F: Soldier_SL_F {

        };
    };

    class Rank {
        class LIEUTENANT {
            headgear = "";
        };
    };
};
