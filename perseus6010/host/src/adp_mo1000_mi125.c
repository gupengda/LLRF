/****************************************************************************
 *
 *    ****                              *
 *   ******                            ***
 *   *******                           ****
 *   ********    ****  ****     **** *********    ******* ****    ***********
 *   *********   ****  ****     **** *********  **************  *************
 *   **** *****  ****  ****     ****   ****    *****    ****** *****     ****
 *   ****  ***** ****  ****     ****   ****   *****      ****  ****      ****
 *  ****    *********  ****     ****   ****   ****       ****  ****      ****
 *  ****     ********  ****    *****  ****    *****     *****  ****      ****
 *  ****      ******   ***** ******   *****    ****** *******  ****** *******
 *  ****        ****   ************    ******   *************   *************
 *  ****         ***     ****  ****     ****      *****  ****     *****  ****
 *                                                                       ****
 *          I N N O V A T I O N  T O D A Y  F O R  T O M O R R O W       ****
 *                                                                        ***
 *
 ************************************************************************//**
 *
 * @file      adp_mo1000_mi125.c
 *
 * @brief     Functions that test the MO1000-MI125 Stack
 *
 * Copyright (C) 2014, Nutaq, Canada. All rights reserved.
 *
 * This file is part of Nutaq’s ADP Software Suite.
 *
 * You may at your option receive a license to Nutaq’s ADP Software Suite under
 * either the terms of the GNU General Public License (GPL) or the
 * Nutaq Professional License, as explained in the note below.
 *
 * Nutaq’s ADP Software Suite may be used under the terms of the GNU General
 * Public License version 3 as published by the Free Software Foundation
 * and appearing in the file LICENSE.GPL included in the packaging of this file.
 *
 * Nutaq’s ADP Software Suite is provided AS IS WITHOUT WARRANTY OF
 * ANY KIND; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A
 * PARTICULAR PURPOSE. See the GNU General Public License for more details.
 *
 * NOTE:
 *
 * Using Nutaq’s ADP Software Suite under the GPL requires that your work based on
 * Nutaq’s ADP Software Suite, if  distributed, must be licensed under the GPL.
 * If you wish to distribute a work based on Nutaq’s ADP Software Suite but desire
 * to license it under your own terms, e.g. a closed source license, you may purchase
 * a Nutaq Professional License.
 *
 * The Professional License, gives you -- under certain conditions -- the right to
 * use any license you wish for your work based on Nutaq’s ADP Software Suite.
 * For the full terms of the Professional License, please contact the Nutaq sales team.
 *
 ****************************************************************************/
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

#ifdef __linux__
#include <Nutaq/eapi.h>
#include <Nutaq/memory_map.h>
#include <Nutaq/adp_types.h>
#include <Nutaq/adp_media_types.h>
#include <Nutaq/adp_bus_access_media_types.h>
#include <Nutaq/adp_bus_access_types.h>
#include <Nutaq/adp_bus_access.h>
#include <Nutaq/linux_utils.h>
#include <Nutaq/MI125_mi125_defines.h>
#include <Nutaq/lyr_error.h>
#include <Nutaq/mo1000_settings.h>
#include <Nutaq/mi125_settings.h>
#else
#include <conio.h>
#include "eapi.h"
#include "memory_map.h"
#include "adp_types.h"
#include "adp_media_types.h"
#include "adp_bus_access_media_types.h"
#include "adp_bus_access_types.h"
#include "adp_bus_access.h"
#include "MI125_mi125_defines.h"
#include "lyr_error.h"
#include "mo1000_settings.h"
#include "mi125_settings.h"
#endif

// WARNING: to run this demo under LINUX, you may need root privilege

/****************************************************************************************************************************
												FMC Default Configuration
****************************************************************************************************************************/
#define DDS_FREQ						10000000			// DDS value in Hz
#define BOTTOM							1					// MO1000 Bottom position
#define TOP								2					// MI125  Top position

/****************************************************************************************************************************
													Test Mode Defines
****************************************************************************************************************************/
#define DDS								0					//to output DDS signal (generated in the FPGA)
#define PASS_THROUGH					1					//to execute a pass-through

/****************************************************************************************************************************
												Configuration Mode Defines
****************************************************************************************************************************/
#define CONFIG_ALL						0					// Configure everything (default)
#define CONFIG_MO1000_BOT				1					// Configure MO1000-Bottom FMC only
#define CONFIG_MI125_TOP				2					// Configure MO1000-Top FMC only
#define CONFIG_DDS						3					// Configure DDS only
#define CONFIG_PASS_THROUGH				4					// Configure Pass-Through only

/****************************************************************************************************************************
												Custom Register Definitions
****************************************************************************************************************************/
#define CANAL_REG						3
#define FIFO_REG						4
#define DDS_FREQ_REG					16
#define DAC_MUX_REG						19

#define DAC_MUX_SEL_DDS					0
#define DAC_MUX_SEL_PASSTRHOUGH			1

/****************************************************************************************************************************
													ADP Handles
****************************************************************************************************************************/
adp_handle_bus_access hBusAccess	  = NULL;

/****************************************************************************************************************************
												Static Functions Declarations
****************************************************************************************************************************/
static int Test_Terminate(void);
static int Validate_Arguments( int argc, 
							   char* argv[],
							   char **pcIpAddrPerseus,
							   unsigned int *uiTestMode,
							   unsigned int *uiConfigurationMode,
							   unsigned int *uiRefClkSource,
							   unsigned int *uiRefClkFrequency,
							   unsigned int *uiDacClkFrequency,
							   unsigned int *uiMasterRefClkFrequency,
							   unsigned int *uiInterpolation,
							   unsigned int *uiActiveChannels,
							   unsigned int *uiMI125ChannelUsed);

/****************************************************************************************************************************
															Main
****************************************************************************************************************************/

int main( int argc, char* argv[] )
{
	adp_result_t res;
	connection_state state;
	char * pcIpAddrPerseus = NULL;

	// Default Mode are in comments
	unsigned int uiTestMode = PASS_THROUGH;											// Pass-Through
	unsigned int uiConfigurationMode = CONFIG_ALL;									// Configure ALL

	/*---MO1000 Bottom---*/
	unsigned int uiMO1000RefClkSource = 0x1;										// Internal
	unsigned int uiRefClkFrequency = 125000000;										// 125 MHz for MO1000
	unsigned int uiDacClkFrequency = 1000000000;									// 1000 MHz for MO1000 DAC
	unsigned int uiInterpolation = 13;												// 8x
	unsigned int uiActiveChannels = 3;												// 8 active channels
	unsigned int uiMasterClkFrequency = 125000000;									// 125 MHz for MI125

	/*---MI125 Top---*/
	unsigned int uiMI125ChannelUsed = 0;											// MI125 Channel 0 Used for Pass-through Mode

	/************************************************************************************************************************
												Example argument validation
	************************************************************************************************************************/

	res = Validate_Arguments(argc, argv, &pcIpAddrPerseus, &uiTestMode, &uiConfigurationMode, &uiMO1000RefClkSource, &uiRefClkFrequency,
									&uiDacClkFrequency, &uiMasterClkFrequency, &uiInterpolation, &uiActiveChannels, &uiMI125ChannelUsed);
	if(FAILURE(res))
	{
		printf( "Error : MO1000 Bottom parameters are invalid\n");
		printf( "The program will terminate. Push any key to continue\n" );
		GETCH();
		return res;
	}

	/************************************************************************************************************************
													Initialization MO1000
	************************************************************************************************************************/

	// Print name of test
	printf( "MO1000-MI125 functional example.\n\n" );

	// Opening connection to Perseus
	printf( "Connecting to Perseus %s \n", pcIpAddrPerseus);
	res  = BusAccess_Ethernet_OpenWithoutConnection(&hBusAccess, (int8_t*)pcIpAddrPerseus, 0);
	if(FAILURE(res))
	{
		printf( "The Perseus is not responding.\n" );
		printf( ErrorToString(res) );
		printf( "\nPlease ensure the Perseus IP address you specified (%s) is correct.\n\n", pcIpAddrPerseus );
		printf( "The program will terminate. Push any key to continue\n" );
		GETCH();
		Test_Terminate();
		return res;
	}
	
	// Getting connection state
	res = BusAccess_GetConnectionState( hBusAccess, &state);
	if(FAILURE(res))
	{
		printf( "Error: Could not retrieve connection state\r\n");
		printf( ErrorToString(res) );
		printf( "\nThe program will terminate. Push any key to continue\n" );
		GETCH();
		Test_Terminate();
		return res;
	}

	printf( "Connected!\n\n" );

	if(uiConfigurationMode == CONFIG_ALL || uiConfigurationMode == CONFIG_MO1000_BOT)
	{
		// Initializing MO1000 Bottom
		printf( "Initializing MO1000 Bottom...\n");
		res = InitMo1000(hBusAccess, BOTTOM, (Mo1000_eClockSource)uiMO1000RefClkSource, uiRefClkFrequency, uiDacClkFrequency, eMo1000MasterClkManual,
						 uiMasterClkFrequency, (Ad9148_eInterpolationMode)uiInterpolation, (Mo1000_eActChannel)uiActiveChannels);
		if(FAILURE(res))
		{
			printf( ErrorToString(res) );
			printf( "\nThe program will terminate. Push any key to continue\n" );
			GETCH();
			Test_Terminate();
			return res;
		}
		printf("Done!\r\n\n");
	}

	if(uiConfigurationMode == CONFIG_ALL || uiConfigurationMode == CONFIG_MI125_TOP)
	{
		// Initializing MI125 Top
		printf( "Initializing MI125 Top...\n");
		res = InitMi125(hBusAccess, TOP, MI125_CLKSRCBOTTOMFMC);
		if(FAILURE(res))
		{
			printf( ErrorToString(res) );
			printf( "\nThe program will terminate. Push any key to continue\n" );
			GETCH();
			Test_Terminate();
			return res;
		}
		printf("Done!\r\n\n");
	}

	/************************************************************************************************************************
														DDS Mode
	************************************************************************************************************************/
	if ( (uiTestMode == DDS && uiConfigurationMode == CONFIG_ALL) || uiConfigurationMode == CONFIG_DDS )
	{
		unsigned long long dds;
		unsigned int uiInterpolationFactor  = 0;

		printf("DDS mode\n");

		// Calculate factor of interpolation to divide Fsampling_DAC to get Fdata
		if ( uiInterpolation == 0 ) // 1x
		{
			uiInterpolationFactor = 1;
		}
		else if ( uiInterpolation >= 1 && uiInterpolation <= 4) // 2x
		{
			uiInterpolationFactor = 2;
		}
		else if ( uiInterpolation >= 5 && uiInterpolation <= 12) // 4x
		{
			uiInterpolationFactor = 4;
		}
		else if ( uiInterpolation >= 13 && uiInterpolation <= 20) // 8x
		{
			uiInterpolationFactor = 8;
		}
		else // Error
		{
			printf( "Cannot evaluate the interpolation factor for calculating the Fdata\n");
			printf( "The program will terminate. Push any key to continue\n" );
			GETCH();
			Test_Terminate();
			return -2;
		}

		// Equation: Fsignal_DDS = (Fdata  *  CR16) / 2^32 ,
		// where Fdata = Fsampling_DAC/Interpolation
		// Goal    : Isolate CR16
		// Result  : CR16 = (Fsignal_DDS  *  2^32) / (Fsampling_DAC/Interpolation)
		printf( "    - Configuring the DDS generator\n");
		dds = (unsigned long long)(DDS_FREQ * 4294967296); // calculate DDS divider
		dds = dds / (uiDacClkFrequency / uiInterpolationFactor);

		// Set DDS values
		res = custom_register_write_send( &state, DDS_FREQ_REG, (unsigned int)dds); 
		if(FAILURE(res))
		{
			printf( ErrorToString(res) );
			printf( "\nThe program will terminate. Push any key to continue\n" );
			GETCH();
			Test_Terminate();
			return res;
		}

		// Set DAC mux to DDS
		printf( "    - Writing %d to DAC mux to enable DDS\n",DAC_MUX_SEL_DDS);
		res = custom_register_write_send( &state, DAC_MUX_REG, DAC_MUX_SEL_DDS);
		if(FAILURE(res))
		{
			printf( ErrorToString(res) );
			printf( "\nThe program will terminate. Push any key to continue\n" );
			GETCH();
			Test_Terminate();
			return res;
		}

		printf("Done!\n\n");
	}
	/************************************************************************************************************************
													Pass-through Mode
	************************************************************************************************************************/
	if ( (uiTestMode == PASS_THROUGH && uiConfigurationMode == CONFIG_ALL) || uiConfigurationMode == CONFIG_PASS_THROUGH )
	{
		printf("Pass-through mode\n");

		// Set DAC mux to ADC (Pass-through)
		printf( "    - Writing %d to DAC mux to enable ADC (Pass-through)\n",DAC_MUX_SEL_PASSTRHOUGH);
		res = custom_register_write_send( &state, DAC_MUX_REG, DAC_MUX_SEL_PASSTRHOUGH);
		if(FAILURE(res))
		{
			printf( ErrorToString(res) );
			printf( "\nThe program will terminate. Push any key to continue\n" );
			GETCH();
			Test_Terminate();
			return res;
		}

		// Set MI125 Channel to use
		printf( "    - Setting MI125 Channel %d to use\n",uiMI125ChannelUsed);
		res = custom_register_write_send( &state, CANAL_REG, uiMI125ChannelUsed);
		if(FAILURE(res))
		{
			printf( ErrorToString(res) );
			printf( "\nThe program will terminate. Push any key to continue\n" );
			GETCH();
			Test_Terminate();
			return res;
		}

		// Resetting asynchrone FIFO
		printf( "    - Resetting asynchrone FIFO\n");
		res = custom_register_write_send( &state, FIFO_REG, 1);
		if(FAILURE(res))
		{
			printf( ErrorToString(res) );
			printf( "\nThe program will terminate. Push any key to continue\n" );
			GETCH();
			Test_Terminate();
			return res;
		}

		// Enabling asynchrone FIFO
		printf( "    - Enabling asynchrone FIFO\n");
		res = custom_register_write_send( &state, FIFO_REG, 0);
		if(FAILURE(res))
		{
			printf( ErrorToString(res) );
			printf( "\nThe program will terminate. Push any key to continue\n" );
			GETCH();
			Test_Terminate();
			return res;
		}

		printf("Done!\n\n");
	}
	
	printf( "Press any key to terminate\n");
	Test_Terminate();
	GETCH();
	return 0;
}

/****************************************************************************************************************************
													Static functions
****************************************************************************************************************************/

static int Test_Terminate(void)
{
	if(hBusAccess != NULL)
	{
		BusAccess_Ethernet_Close(hBusAccess);
	}
	return 0;
}

static int Mo1000_Validate_Ref_Clock_Source(unsigned int uiRefClockSource);
static int Mo1000_Validate_Interpolation(unsigned int uiInterpolationMode);
static int Mo1000_Validate_Active_Channels(unsigned int uiActChannel);
static int Mo1000_Validate_Test_Mode(unsigned int uiTestMode);
static int Mo1000_Validate_Configuration_Mode(unsigned int uiConfigurationMode);
static int Mi125_Validate_Channel_Used(unsigned int uiMI125ChannelUsed);

static int Validate_Arguments( int argc, 
							   char* argv[],
							   char **pcIpAddrPerseus,
							   unsigned int *uiTestMode,
							   unsigned int *uiConfigurationMode,
							   unsigned int *uiRefClkSource,
							   unsigned int *uiRefClkFrequency,
							   unsigned int *uiDacClkFrequency,
							   unsigned int *uiMasterRefClkFrequency,
							   unsigned int *uiInterpolation,
							   unsigned int *uiActiveChannels,
							   unsigned int *uiMI125ChannelUsed)
{
	int res;
	unsigned int uiChoice, uiParameter;
	
	//pcIpAddrPerseus					argv[1]					192.168.0.101
	//uiTestMode						argv[2]					0 = Passthrough, 1 = DDS
	//uiConfigurationMode				argv[3]					0 = All, 1 = Config MO1000-Bottom, 2 = Config MI125-Top, 3 = Config DDS, 4 = Config Pass-Through
	//uiRefClkSource					argv[4]					0 = FMC Carrier CLK2, 1 = Internal, 2 = External, 4 = FMC Carrier CLK3
	//uiRefClkFrequency					argv[5]					in Hz
	//uiDacClkFrequency					argv[6]					in Hz
	//uiMasterRefClkFrequency			argv[7]					in Hz, because MasterRefMode is manual
	//uiInterpolation					argv[8]					1x = 0, 2x = 1, 4x = 5, 8x = 13
	//uiActiveChannels					argv[9]					0 = 2 channels, 1 = 4 channels, 2 = 6 channels, 3 = 8 channels
	//uiMI125ChannelUsed				argv[10]				0 for channel 0, 1 for channel 1, etc.

	if(!(argc <= 11 && argc >= 2))
	{
		printf( "Error: Wrong number of parameters\n"
				"Parameter 1 must be the Perseus IP address, ex 192.168.0.1,\n");
		return -1;
	}

	*pcIpAddrPerseus = argv[1];

	//----------------------------------------------Show Default Parameters-----------------------------------------------------
	if (argc != 11 )
	{
		while(1)
		{
			printf("-------------Example Default Parameters------------\n");

			//Test Mode
			printf("    - Test Mode = %u, ",*uiTestMode);
			switch(*uiTestMode)
			{
				case 0:
				{
					printf("to output DDS signal (generated in the FPGA)\n");
					break;
				}
				case 1:
				{
					printf("to execute a pass-through \n");
					break;
				}
			}

			//Configuration Mode
			printf("    - Configuration Mode = %u, ",*uiConfigurationMode);
			switch(*uiConfigurationMode)
			{
				case CONFIG_ALL:
				{
					printf("Configure everything (default)\n");
					break;
				}
				case CONFIG_MO1000_BOT:
				{
					printf("Configure MO1000-Bottom FMC only \n");
					break;
				}
				case CONFIG_MI125_TOP:
				{
					printf("Configure MI125-Top FMC only \n");
					break;
				}
				case CONFIG_DDS:
				{
					printf("Configure DDS only \n");
					break;
				}
				case CONFIG_PASS_THROUGH:
				{
					printf("Configure Pass-Through only \n");
					break;
				}
			}
			printf("\n");

			//Bottom MO1000
			printf("----------MO1000 Bottom Default Parameters---------\n");

			//Reference Clock Source
			printf("    - Reference Clock Source = %u, ",*uiRefClkSource);
			switch(*uiRefClkSource)
			{
				case eMo1000ClkSrcFmccarrier2:
				{
					printf("FMC carrier CLK2 clock\n");
					break;
				}
				case eMo1000ClkSrc125mhz:
				{
					printf("Internal 125 MHz \n");
					break;
				}
				case eMo1000ClkSrcExt:
				{
					printf("External clock\n");
					break;
				}
				case eMo1000ClkSrcFmccarrier3:
				{
					printf("FMC carrier CLK3 clock\n");
					break;
				}
			}

			//Reference Clock Frequency
			printf("    - Reference Clock Frequency = %u Hz\n",*uiRefClkFrequency);

			//DAC Clock Frequency
			printf("    - DAC Clock Frequency = %u Hz\n",*uiDacClkFrequency);

			//Master Refenrece Clock Frequency
			printf("    - Master Reference Clock Frequency = %u Hz\n",*uiMasterRefClkFrequency);

			//Interpolation Mode
			printf("    - Interpolation Mode = %u, ",*uiInterpolation);
			switch(*uiInterpolation)
			{
				case eAd9148Inter1x:
				{
					printf("1x\n");
					break;
				}
				case eAd9148Inter2x:
				{
					printf("2x\n");
					break;
				}
				case eAd9148Inter4x:
				{
					printf("4x\n");
					break;
				}
				case eAd9148Inter8x:
				{
					printf("8x\n");
					break;
				}
			}

			//Active Channels
			printf("    - Active Channels = %u, ",*uiActiveChannels);
			switch(*uiActiveChannels)
			{
				case eMo1000ActChannels02:
				{
					printf("02 channels active\n");
					break;
				}
				case eMo1000ActChannels04:
				{
					printf("04 channels active\n");
					break;
				}
				case eMo1000ActChannels06:
				{
					printf("06 channels active\n");
					break;
				}
				case eMo1000ActChannels08:
				{
					printf("08 channels active (all channels)\n");
					break;
				}
			}
			printf("\n");

			//Top MI125
			printf("------------MI125 Top Default Parameters-----------\n");

			//MI125 Channel Used
			printf("    - Channel Used = %u\n",*uiMI125ChannelUsed);
			printf("\n");

			//---------------------------------------------------Ask Choice--------------------------------------------------------------
			printf("Would you like to change the default parameters? (y/n)\n");
			while(1)
			{
				uiChoice = GETCH();
				printf("Choice is : %c\n", (char)uiChoice);
				if ( (char)uiChoice == 'y' || (char)uiChoice == 'Y' || (char)uiChoice == 'n' || (char)uiChoice == 'N' )
				{
					break;
				}
				else
				{
					printf("Bad input, Try again\n");
				}
			}
			printf("\n");

			//----------------------------------------------Change Default Parameters-----------------------------------------------------
			if (uiChoice == 'y' || uiChoice == 'Y')
			{
				printf("What parameters do you want to change?\n"
					" - Type '0' for Test Mode\n"
					" - Type '1' for Configuration Mode\n"
					" - Type '2' for Reference Clock Source\n"
					" - Type '3' for Reference Clock Frequency\n"
					" - Type '4' for DAC Clock Frequency\n"
					" - Type '5' for Master Reference Clock Frequency\n"
					" - Type '6' for Interpolation Mode\n"
					" - Type '7' for Active Channels\n"
					" - Type '8' for MI125 Channel Used\n"
					"\n");
				do
				{
					uiParameter = GETCH() - '0';
					printf("Choice is %u\n", uiParameter);
				} while ( uiParameter < 0 || uiParameter > 8 );
				printf("\n");

				switch (uiParameter)
				{
					case 0: // Test Mode
					{
						do
						{
							printf( "Choose the data path:\n"
								" - Type '0' to output DDS signal (generated in the FPGA)\n"
								" - Type '1' to execute a pass-through \n"
								"\n" );
							*uiTestMode = GETCH() - '0';
							printf( "Your choice is : %u\n\n",*uiTestMode);
						} while (Mo1000_Validate_Test_Mode(*uiTestMode));
						break;
					}
					case 1: // Configuration Mode
					{
						do
						{
							printf( "Choose the configuration mode:\n"
								" - Type '0' to configure everything (default)\n"
								" - Type '1' to configure MO1000-Bottom FMC only\n"
								" - Type '2' to configure MI125-Top FMC only\n"
								" - Type '3' to configure DDS only\n"
								" - Type '4' to configure Pass-Through only\n"
								"\n" );
							*uiConfigurationMode = GETCH() - '0';
							printf( "Your choice is : %u\n\n",*uiConfigurationMode);
						} while (Mo1000_Validate_Configuration_Mode(*uiConfigurationMode));
						break;
					}
					case 2: // Reference Clock Source
					{
						do
						{
							printf( "Choose the clock source:\n"
								" - Type '0' for FMC carrier CLK2 clock\n"
								" - Type '1' for internal 125 MHz clock\n"
								" - Type '3' for external clock\n"
								" - Type '4' for FMC carrier CLK3 clock\n"
								"\n" );
							*uiRefClkSource = GETCH() - '0';
							printf( "Your choice is : %u\n\n",*uiRefClkSource);
						} while(Mo1000_Validate_Ref_Clock_Source(*uiRefClkSource));
						
						break;
					}
					case 3: // Reference Clock Frequency
					{
						printf( "Enter clock source frequency in Hz:\n" );
						scanf("%u", uiRefClkFrequency);
						printf("\n");
						break;
					}
					case 4: // DAC Clock Frequency
					{
						printf( "Enter DAC clock frequency in Hz:\n" );
						scanf("%u", uiDacClkFrequency);
						printf("\n");
						break;
					}
					case 5: // Master Reference Clock Frequency
					{
						printf( "Enter Master reference clock frequency in Hz:\n" );
						scanf("%u", uiMasterRefClkFrequency);
						printf("\n");
						break;
					}
					case 6: // Interpolation Mode
					{
						do
						{
							printf( "Choose the DAC interpolation factor:\n"
								" - Type '0' for 1x\n"
								" - Type '1' for 2x\n"
								" - Type '2' for 4x\n"
								" - Type '3' for 8x\n"
								"\n" );
							uiChoice = GETCH() - '0';
							printf( "Your choice is : %u\n\n",uiChoice);
							switch(uiChoice)
							{
							default:
								*uiInterpolation = -1;
								break;
							case 0:
								*uiInterpolation = eAd9148Inter1x;
								break;
							case 1:
								*uiInterpolation = eAd9148Inter2x;
								break;
							case 2:
								*uiInterpolation = eAd9148Inter4x;
								break;
							case 3:
								*uiInterpolation = eAd9148Inter8x;
								break;
							}
						} while(Mo1000_Validate_Interpolation(*uiInterpolation));
						break;
					}
					case 7: // Active Channels
					{
						do
						{
							printf( "Choose the DAC active channels:\n"
								" - Type '0' for 2 channels\n"
								" - Type '1' for 4 channels\n"
								" - Type '2' for 6 channels\n"
								" - Type '3' for 8 channels\n"
								"\n" );
							*uiActiveChannels = GETCH() - '0';
							printf( "Your choice is : %u\n\n",*uiActiveChannels);
						} while (Mo1000_Validate_Active_Channels(*uiActiveChannels));
						break;
					}
					case 8: // MI125 Channel Used
					{
						printf( "Enter the MI125 Channel to be used from range [0,15]:\n" );
						do
						{
							scanf("%u", uiMI125ChannelUsed);
							printf("\n");
							printf( "Your choice is : %u\n\n",*uiMI125ChannelUsed);
						} while (Mi125_Validate_Channel_Used(*uiMI125ChannelUsed));
						break;
					}
					default :
					{
						break;
					}
				}
			}
			//------------------------------------------------Keep Current Parameters------------------------------------------------------
			else
			{
				break;
			}
		}
	}
	else // If we pass argument directly from Batch file
	{
		*uiTestMode = atoi(argv[2]);
		*uiConfigurationMode = atoi(argv[3]);
		*uiRefClkSource = atoi(argv[4]);
		*uiRefClkFrequency = atoi(argv[5]);
		*uiDacClkFrequency = atoi(argv[6]);
		*uiMasterRefClkFrequency = atoi(argv[7]);
		*uiInterpolation = atoi(argv[8]);
		*uiActiveChannels = atoi(argv[9]);
		*uiMI125ChannelUsed = atoi(argv[10]);

		//Validate parameters
		res = Mo1000_Validate_Test_Mode(*uiTestMode);
		if (res != 0)
		{
			printf( "Error: Wrong test mode config parameter (different 0, 1)\n");
			return -2;
		}

		res = Mo1000_Validate_Configuration_Mode(*uiConfigurationMode);
		if (res != 0)
		{
			printf( "Error: Wrong configuration mode config parameter (different 0, 1, 2, 3, 4)\n");
			return -4;
		}

		res = Mo1000_Validate_Ref_Clock_Source(*uiRefClkSource);
		if (res != 0)
		{
			printf( "Error: Wrong ref clock source config parameter (different 0, 1, 2, 4)\n");
			return -3;
		}

		res = Mo1000_Validate_Interpolation(*uiInterpolation);
		if (res != 0)
		{
			printf( "Error: Wrong interpolation config parameter\n");
			return -4;
		}

		res = Mo1000_Validate_Active_Channels(*uiActiveChannels);
		if (res != 0)
		{
			printf( "Error: Wrong DAC active channels config parameter (different 0, 1, 2, 3)\n");
			return -5;
		}

		res = Mi125_Validate_Channel_Used(*uiMI125ChannelUsed);
		if (res != 0)
		{
			printf( "Error: Wrong MI125 channel used config parameter (different from range [0-15])\n");
			return -6;
		}
	}
	return 0;
}

// Validate Reference Clock Source, returns 0 if parameter is valid
static int Mo1000_Validate_Ref_Clock_Source(unsigned int uiRefClkSource)
{
	return !(uiRefClkSource == 0 || uiRefClkSource == 1 || uiRefClkSource == 3 || uiRefClkSource == 4);
}

// Validate Interpolation Mode, returns 0 if parameter is valid
static int Mo1000_Validate_Interpolation(unsigned int uiInterpolationMode)
{
	return !(uiInterpolationMode >= 0 && uiInterpolationMode <= 20);
}

// Validate Active Channels Mode, returns 0 if parameter is valid
static int Mo1000_Validate_Active_Channels(unsigned int uiActChannel)
{
	return !(uiActChannel >= 0 && uiActChannel <= 3);
}

// Validate Test Mode, returns 0 if parameter is valid
static int Mo1000_Validate_Test_Mode(unsigned int uiTestMode)
{
	return !(uiTestMode >= 0 && uiTestMode <= 1);
}

// Validate Configuration Mode, returns 0 if parameter is valid
static int Mo1000_Validate_Configuration_Mode(unsigned int uiConfigurationMode)
{
	return !(uiConfigurationMode >= 0 && uiConfigurationMode <= 4);
}

// Validate MI125 Channel Used, returns 0 if parameter is valid
static int Mi125_Validate_Channel_Used(unsigned int uiMI125ChannelUsed)
{
	return !(uiMI125ChannelUsed >= 0 && uiMI125ChannelUsed <= 15);
}
