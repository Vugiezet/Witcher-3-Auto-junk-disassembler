class CAutoJunkDisassembler
{
	private var isProcessing : bool;

	public function IsModEnabled() : bool
	{
		var inGameConfig : CInGameConfigWrapper;
		var val : string;

		inGameConfig = theGame.GetInGameConfigWrapper();
		if ( !inGameConfig )
		{
			return true;
		}

		val = inGameConfig.GetVarValue( 'ModAutoJunkDisassembler', 'EnableMod' );
		if ( val == "" )
		{
			return true;
		}

		return val == "true";
	}

	public function ShouldDisassembleJunk() : bool
	{
		var inGameConfig : CInGameConfigWrapper;
		var val : string;

		inGameConfig = theGame.GetInGameConfigWrapper();
		if ( !inGameConfig )
		{
			return true;
		}

		val = inGameConfig.GetVarValue( 'ModAutoJunkDisassembler', 'DisassembleJunk' );
		if ( val == "" )
		{
			return true;
		}

		return val == "true";
	}

	public function GetMaxWeaponsTier() : int
	{
		var inGameConfig : CInGameConfigWrapper;
		var val : string;

		inGameConfig = theGame.GetInGameConfigWrapper();
		if ( !inGameConfig )
		{
			return 1;
		}

		val = inGameConfig.GetVarValue( 'ModAutoJunkDisassembler', 'WeaponsMaxTier' );
		if ( val == "" )
		{
			return 1;
		}

		return StringToInt( val, 1 );
	}

	public function GetMaxArmorTier() : int
	{
		var inGameConfig : CInGameConfigWrapper;
		var val : string;

		inGameConfig = theGame.GetInGameConfigWrapper();
		if ( !inGameConfig )
		{
			return 1;
		}

		val = inGameConfig.GetVarValue( 'ModAutoJunkDisassembler', 'ArmorMaxTier' );
		if ( val == "" )
		{
			return 1;
		}

		return StringToInt( val, 1 );
	}

	public function ShouldProtectWitcherGear() : bool
	{
		var inGameConfig : CInGameConfigWrapper;
		var val : string;

		inGameConfig = theGame.GetInGameConfigWrapper();
		if ( !inGameConfig )
		{
			return true;
		}

		val = inGameConfig.GetVarValue( 'ModAutoJunkDisassembler', 'ProtectWitcherGear' );
		if ( val == "" )
		{
			return true;
		}

		return val == "true";
	}

	public function ShouldProtectRelics() : bool
	{
		var inGameConfig : CInGameConfigWrapper;
		var val : string;

		inGameConfig = theGame.GetInGameConfigWrapper();
		if ( !inGameConfig )
		{
			return true;
		}

		val = inGameConfig.GetVarValue( 'ModAutoJunkDisassembler', 'ProtectRelics' );
		if ( val == "" )
		{
			return true;
		}

		return val == "true";
	}

	public function ShouldExtractRunes() : bool
	{
		var inGameConfig : CInGameConfigWrapper;
		var val : string;

		inGameConfig = theGame.GetInGameConfigWrapper();
		if ( !inGameConfig )
		{
			return true;
		}

		val = inGameConfig.GetVarValue( 'ModAutoJunkDisassembler', 'ExtractRunes' );
		if ( val == "" )
		{
			return true;
		}

		return val == "true";
	}

	public function ShouldPayFee() : bool
	{
		var inGameConfig : CInGameConfigWrapper;
		var val : string;

		inGameConfig = theGame.GetInGameConfigWrapper();
		if ( !inGameConfig )
		{
			return false;
		}

		val = inGameConfig.GetVarValue( 'ModAutoJunkDisassembler', 'PayBlacksmithFee' );
		if ( val == "" )
		{
			return false;
		}

		return val == "true";
	}

	public function GetNotificationMode() : int
	{
		var inGameConfig : CInGameConfigWrapper;
		var val : string;

		inGameConfig = theGame.GetInGameConfigWrapper();
		if ( !inGameConfig )
		{
			return 2;
		}

		val = inGameConfig.GetVarValue( 'ModAutoJunkDisassembler', 'NotificationMode' );
		if ( val == "" )
		{
			return 2;
		}

		return StringToInt( val, 2 );
	}

	public function ProcessLootedItem( sourceInv : CInventoryComponent, playerInv : CInventoryComponent, itemId : SItemUniqueId, quantity : int ) : void
	{
		var sourceEntity : CEntity;
		var sourceContainer : W3Container;
		var parts : array<SItemParts>;
		var runesList : array<name>;
		var itemQuality : int;
		var isJunk, isWeapon, isArmor, shouldDismantle : bool;
		var dismantleCount : int;
		var invItem : SInventoryItem;
		var feeUnit, totalFee : int;
		var i, partYield : int;
		var itemNameStr, addedSummary, partNameStr, notifyText : string;

		if ( isProcessing || !IsModEnabled() )
		{
			return;
		}

		if ( !sourceInv || !playerInv || !playerInv.IsIdValid( itemId ) )
		{
			return;
		}

		if ( playerInv != thePlayer.inv )
		{
			return;
		}

		sourceEntity = sourceInv.GetEntity();
		sourceContainer = (W3Container)sourceEntity;
		// Player stash and decorative mounts must not trigger automatic recycling.
		if ( !sourceContainer || (W3PlayerStash)sourceContainer || (W3DisplayMount)sourceContainer )
		{
			return;
		}

		if ( playerInv.IsItemQuest( itemId ) || playerInv.ItemHasTag( itemId, 'Quest' ) )
		{
			return;
		}

		if ( playerInv.ItemHasTag( itemId, 'NoDrop' ) || playerInv.ItemHasTag( itemId, theGame.params.TAG_DONT_SHOW ) )
		{
			return;
		}

		if ( thePlayer.IsItemEquipped( itemId ) )
		{
			return;
		}

		if ( playerInv.IsItemReadable( itemId ) || playerInv.IsItemTrophy( itemId ) || playerInv.IsItemTool( itemId ) || playerInv.IsItemDismantleKit( itemId ) )
		{
			return;
		}

		if ( playerInv.ItemHasTag( itemId, 'HorseBag' ) || playerInv.ItemHasTag( itemId, 'HorseBlinders' ) || playerInv.ItemHasTag( itemId, 'HorseSaddle' ) )
		{
			return;
		}

		isJunk = playerInv.IsItemJunk( itemId ) || playerInv.GetItemCategory( itemId ) == 'junk' || playerInv.ItemHasTag( itemId, 'junk' );

		// Preserve raw crafting components and alchemy items that are not classed as junk.
		if ( ( playerInv.IsItemIngredient( itemId ) || playerInv.IsItemAlchemyItem( itemId ) ) && !isJunk )
		{
			return;
		}

		parts = playerInv.GetItemRecyclingParts( itemId );
		if ( parts.Size() == 0 )
		{
			return;
		}

		itemQuality = playerInv.GetItemQuality( itemId );

		if ( ShouldProtectWitcherGear() )
		{
			if ( itemQuality >= 5 || playerInv.ItemHasTag( itemId, 'WitcherSpecItem' ) || playerInv.ItemHasTag( itemId, 'SetItem' ) )
			{
				return;
			}
		}

		if ( ShouldProtectRelics() && itemQuality == 4 )
		{
			return;
		}

		isWeapon = playerInv.IsItemWeapon( itemId ) || playerInv.IsItemCrossbow( itemId ) || playerInv.ItemHasTag( itemId, 'Weapon' );
		isArmor = playerInv.IsItemAnyArmor( itemId ) || playerInv.IsItemChestArmor( itemId ) || playerInv.IsItemBoots( itemId ) || playerInv.IsItemGloves( itemId ) || playerInv.IsItemPants( itemId );

		shouldDismantle = false;

		if ( isJunk && ShouldDisassembleJunk() )
		{
			shouldDismantle = true;
		}
		else if ( isWeapon && GetMaxWeaponsTier() > 0 && itemQuality <= GetMaxWeaponsTier() )
		{
			shouldDismantle = true;
		}
		else if ( isArmor && GetMaxArmorTier() > 0 && itemQuality <= GetMaxArmorTier() )
		{
			shouldDismantle = true;
		}

		if ( !shouldDismantle )
		{
			return;
		}

		dismantleCount = Clamp( quantity, 1, playerInv.GetItemQuantity( itemId ) );

		if ( ShouldPayFee() )
		{
			invItem = playerInv.GetItem( itemId );
			feeUnit = playerInv.GetItemPriceDisassemble( invItem );
			totalFee = feeUnit * dismantleCount;
			if ( totalFee > 0 )
			{
				if ( playerInv.GetMoney() < totalFee )
				{
					return;
				}
				playerInv.RemoveMoney( totalFee );
			}
		}

		isProcessing = true;

		itemNameStr = GetLocStringByKeyExt( playerInv.GetItemLocalizedNameByUniqueID( itemId ) );

		if ( ShouldExtractRunes() && playerInv.GetItemEnhancementCount( itemId ) > 0 && !playerInv.IsItemEnchanted( itemId ) )
		{
			playerInv.GetItemEnhancementItems( itemId, runesList );
			for ( i = 0; i < runesList.Size(); i += 1 )
			{
				playerInv.AddAnItem( runesList[i], 1, false, false );
			}
		}

		addedSummary = "";
		for ( i = 0; i < parts.Size(); i += 1 )
		{
			partYield = parts[i].quantity * dismantleCount;
			if ( partYield > 0 )
			{
				playerInv.AddAnItem( parts[i].itemName, partYield, false, false );
				partNameStr = GetLocStringByKeyExt( playerInv.GetItemLocalizedNameByName( parts[i].itemName ) );
				if ( addedSummary != "" )
				{
					addedSummary += ", ";
				}
				addedSummary += partNameStr + " x" + IntToString( partYield );
			}
		}

		playerInv.RemoveItem( itemId, dismantleCount );

		isProcessing = false;

		if ( GetNotificationMode() > 0 && itemNameStr != "" )
		{
			notifyText = "<font color=\"#d4a259\">" + GetLocStringByKeyExt( "panel_blacksmith_items_removed" ) + ": </font>"
				+ itemNameStr + " x" + IntToString( dismantleCount )
				+ "<br/><font color=\"#6ca365\">" + GetLocStringByKeyExt( "panel_blacksmith_items_added" ) + ": </font>"
				+ addedSummary;

			if ( GetNotificationMode() == 2 )
			{
				theGame.GetGuiManager().ShowNotification( notifyText, 4.0 );
			}
			else
			{
				thePlayer.DisplayHudMessage( itemNameStr + " -> " + addedSummary );
			}
		}
	}
}

var g_autoJunkDisassembler : CAutoJunkDisassembler;

function GetAutoJunkDisassembler() : CAutoJunkDisassembler
{
	if ( !g_autoJunkDisassembler )
	{
		g_autoJunkDisassembler = new CAutoJunkDisassembler in theGame;
	}
	return g_autoJunkDisassembler;
}

function AutoJunkDisassembler_OnItemLooted( sourceInv : CInventoryComponent, playerInv : CInventoryComponent, itemId : SItemUniqueId, quantity : int ) : void
{
	GetAutoJunkDisassembler().ProcessLootedItem( sourceInv, playerInv, itemId, quantity );
}
