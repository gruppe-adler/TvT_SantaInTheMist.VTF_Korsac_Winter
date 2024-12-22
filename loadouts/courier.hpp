class courier {
    class Type {
        class man_p_fugitive_F {
            uniform = "xmas_santa_ind_uniform";
            vest = "";
            backpack = "";
            headgear = "H_Hat_brown";
            goggles = "";

            primaryWeapon = "";
            primaryWeaponOptics = "";
            primaryWeaponMagazine = "";
            primaryWeaponPointer = "";
            primaryWeaponMuzzle = "";
            primaryWeaponUnderbarrel = "";
            primaryWeaponUnderbarrelMagazine = "";

            secondaryWeapon = "";
            secondaryWeaponMagazine = "";

            handgunWeapon = "rhs_weap_pb_6p9";
            handgunWeaponMagazine = "rhs_mag_9x18_8_57N181S";

            binoculars = "";
            map = "ItemMap";
            compass = "ItemCompass";
            watch = "tf_microdagr";
            gps = "ItemGPS";
            radio = "tf_rf7800str";
            nvgoggles = "";

            addItemsToUniform[] = {
                LIST_6("ACE_fieldDressing"),
                LIST_4("ACE_morphine"),
                "ACE_epinephrine",
                "ACE_Flashlight_KSF1",
                "ACE_key_lockpick",
                "ACE_MapTools",
                LIST_4("rhs_mag_9x18_8_57N181S")
            };
            addItemsToVest[] = {};
            addItemsToBackpack[] = {};
        };
    };
    class Rank {
        class LIEUTENANT {
            uniform = "xmas_santa_uniform";
            handgunWeapon = "";
            handgunWeaponMagazine = "";

            addItemsToUniform[] = {
                LIST_6("ACE_fieldDressing"),
                LIST_4("ACE_morphine"),
                "ACE_epinephrine",
                "ACE_Flashlight_KSF1",
                "ACE_key_lockpick",
                "ACE_MapTools",
                LIST_4("xmas_explosive_present")
            };
        };
    };
};
