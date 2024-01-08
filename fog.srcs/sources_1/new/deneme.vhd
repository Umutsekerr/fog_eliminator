-- -------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY FogRectification IS
  PORT( clk                               :   IN    std_logic;
        reset                             :   IN    std_logic;
        clk_enable                        :   IN    std_logic;
        pixelIn_0                         :   IN    std_logic_vector(7 DOWNTO 0);  -- uint8
        pixelIn_1                         :   IN    std_logic_vector(7 DOWNTO 0);  -- uint8
        pixelIn_2                         :   IN    std_logic_vector(7 DOWNTO 0);  -- uint8
        ctrlIn_hStart                     :   IN    std_logic;
        ctrlIn_hEnd                       :   IN    std_logic;
        ctrlIn_vStart                     :   IN    std_logic;
        ctrlIn_vEnd                       :   IN    std_logic;
        ctrlIn_valid                      :   IN    std_logic;
        bufferR                           :   IN    std_logic_vector(7 DOWNTO 0);  -- uint8
        bufferG                           :   IN    std_logic_vector(7 DOWNTO 0);  -- uint8
        bufferB                           :   IN    std_logic_vector(7 DOWNTO 0);  -- uint8
        ctrlBusIn_hStart                  :   IN    std_logic;
        ctrlBusIn_hEnd                    :   IN    std_logic;
        ctrlBusIn_vStart                  :   IN    std_logic;
        ctrlBusIn_vEnd                    :   IN    std_logic;
        ctrlBusIn_valid                   :   IN    std_logic;
        ce_out                            :   OUT   std_logic;
        pixOut_0                          :   OUT   std_logic_vector(7 DOWNTO 0);  -- uint8
        pixOut_1                          :   OUT   std_logic_vector(7 DOWNTO 0);  -- uint8
        pixOut_2                          :   OUT   std_logic_vector(7 DOWNTO 0);  -- uint8
        ctrlOut_hStart                    :   OUT   std_logic;
        ctrlOut_hEnd                      :   OUT   std_logic;
        ctrlOut_vStart                    :   OUT   std_logic;
        ctrlOut_vEnd                      :   OUT   std_logic;
        ctrlOut_valid                     :   OUT   std_logic;
        pop                               :   OUT   std_logic;
        defogPixOut_0                     :   OUT   std_logic_vector(7 DOWNTO 0);  -- uint8
        defogPixOut_1                     :   OUT   std_logic_vector(7 DOWNTO 0);  -- uint8
        defogPixOut_2                     :   OUT   std_logic_vector(7 DOWNTO 0);  -- uint8
        defogCtrlOut_hStart               :   OUT   std_logic;
        defogCtrlOut_hEnd                 :   OUT   std_logic;
        defogCtrlOut_vStart               :   OUT   std_logic;
        defogCtrlOut_vEnd                 :   OUT   std_logic;
        defogCtrlOut_valid                :   OUT   std_logic;
        popVB                             :   OUT   std_logic
        );
END FogRectification;


ARCHITECTURE rtl OF FogRectification IS

  -- Component Declarations
  COMPONENT FogRemoval
    PORT( clk                             :   IN    std_logic;
          reset                           :   IN    std_logic;
          enb                             :   IN    std_logic;
          pixelIn_0                       :   IN    std_logic_vector(7 DOWNTO 0);  -- uint8
          pixelIn_1                       :   IN    std_logic_vector(7 DOWNTO 0);  -- uint8
          pixelIn_2                       :   IN    std_logic_vector(7 DOWNTO 0);  -- uint8
          ctrlIn_hStart                   :   IN    std_logic;
          ctrlIn_hEnd                     :   IN    std_logic;
          ctrlIn_vStart                   :   IN    std_logic;
          ctrlIn_vEnd                     :   IN    std_logic;
          ctrlIn_valid                    :   IN    std_logic;
          defogPixOut_0                   :   OUT   std_logic_vector(7 DOWNTO 0);  -- uint8
          defogPixOut_1                   :   OUT   std_logic_vector(7 DOWNTO 0);  -- uint8
          defogPixOut_2                   :   OUT   std_logic_vector(7 DOWNTO 0);  -- uint8
          defogCtrlOut_hStart             :   OUT   std_logic;
          defogCtrlOut_hEnd               :   OUT   std_logic;
          defogCtrlOut_vStart             :   OUT   std_logic;
          defogCtrlOut_vEnd               :   OUT   std_logic;
          defogCtrlOut_valid              :   OUT   std_logic
          );
  END COMPONENT;

  COMPONENT ContrastEnhancement
    PORT( clk                             :   IN    std_logic;
          reset                           :   IN    std_logic;
          enb                             :   IN    std_logic;
          pixelIn_0                       :   IN    std_logic_vector(7 DOWNTO 0);  -- uint8
          pixelIn_1                       :   IN    std_logic_vector(7 DOWNTO 0);  -- uint8
          pixelIn_2                       :   IN    std_logic_vector(7 DOWNTO 0);  -- uint8
          ctrlIn_hStart                   :   IN    std_logic;
          ctrlIn_hEnd                     :   IN    std_logic;
          ctrlIn_vStart                   :   IN    std_logic;
          ctrlIn_vEnd                     :   IN    std_logic;
          ctrlIn_valid                    :   IN    std_logic;
          bufferR                         :   IN    std_logic_vector(7 DOWNTO 0);  -- uint8
          bufferG                         :   IN    std_logic_vector(7 DOWNTO 0);  -- uint8
          bufferB                         :   IN    std_logic_vector(7 DOWNTO 0);  -- uint8
          ctrlBusIn_hStart                :   IN    std_logic;
          ctrlBusIn_hEnd                  :   IN    std_logic;
          ctrlBusIn_vStart                :   IN    std_logic;
          ctrlBusIn_vEnd                  :   IN    std_logic;
          ctrlBusIn_valid                 :   IN    std_logic;
          pixelOut_0                      :   OUT   std_logic_vector(7 DOWNTO 0);  -- uint8
          pixelOut_1                      :   OUT   std_logic_vector(7 DOWNTO 0);  -- uint8
          pixelOut_2                      :   OUT   std_logic_vector(7 DOWNTO 0);  -- uint8
          ctrlBusOut_hStart               :   OUT   std_logic;
          ctrlBusOut_hEnd                 :   OUT   std_logic;
          ctrlBusOut_vStart               :   OUT   std_logic;
          ctrlBusOut_vEnd                 :   OUT   std_logic;
          ctrlBusOut_valid                :   OUT   std_logic;
          pop                             :   OUT   std_logic;
          popVB                           :   OUT   std_logic
          );
  END COMPONENT;

  -- Component Configuration Statements
  FOR ALL : FogRemoval
    USE ENTITY work.FogRemoval(rtl);

  FOR ALL : ContrastEnhancement
    USE ENTITY work.ContrastEnhancement(rtl);

  -- Signals
  SIGNAL FogRemoval_out1_0                : std_logic_vector(7 DOWNTO 0);  -- ufix8
  SIGNAL FogRemoval_out1_1                : std_logic_vector(7 DOWNTO 0);  -- ufix8
  SIGNAL FogRemoval_out1_2                : std_logic_vector(7 DOWNTO 0);  -- ufix8
  SIGNAL FogRemoval_out2_hStart           : std_logic;
  SIGNAL FogRemoval_out2_hEnd             : std_logic;
  SIGNAL FogRemoval_out2_vStart           : std_logic;
  SIGNAL FogRemoval_out2_vEnd             : std_logic;
  SIGNAL FogRemoval_out2_valid            : std_logic;
  SIGNAL ContrastEnhancement_out1_0       : std_logic_vector(7 DOWNTO 0);  -- ufix8
  SIGNAL ContrastEnhancement_out1_1       : std_logic_vector(7 DOWNTO 0);  -- ufix8
  SIGNAL ContrastEnhancement_out1_2       : std_logic_vector(7 DOWNTO 0);  -- ufix8
  SIGNAL ContrastEnhancement_out2_hStart  : std_logic;
  SIGNAL ContrastEnhancement_out2_hEnd    : std_logic;
  SIGNAL ContrastEnhancement_out2_vStart  : std_logic;
  SIGNAL ContrastEnhancement_out2_vEnd    : std_logic;
  SIGNAL ContrastEnhancement_out2_valid   : std_logic;
  SIGNAL ContrastEnhancement_out3         : std_logic;
  SIGNAL ContrastEnhancement_out4         : std_logic;

BEGIN
  u_FogRemoval : FogRemoval
    PORT MAP( clk => clk,
              reset => reset,
              enb => clk_enable,
              pixelIn_0 => pixelIn_0,  -- uint8
              pixelIn_1 => pixelIn_1,  -- uint8
              pixelIn_2 => pixelIn_2,  -- uint8
              ctrlIn_hStart => ctrlIn_hStart,
              ctrlIn_hEnd => ctrlIn_hEnd,
              ctrlIn_vStart => ctrlIn_vStart,
              ctrlIn_vEnd => ctrlIn_vEnd,
              ctrlIn_valid => ctrlIn_valid,
              defogPixOut_0 => FogRemoval_out1_0,  -- uint8
              defogPixOut_1 => FogRemoval_out1_1,  -- uint8
              defogPixOut_2 => FogRemoval_out1_2,  -- uint8
              defogCtrlOut_hStart => FogRemoval_out2_hStart,
              defogCtrlOut_hEnd => FogRemoval_out2_hEnd,
              defogCtrlOut_vStart => FogRemoval_out2_vStart,
              defogCtrlOut_vEnd => FogRemoval_out2_vEnd,
              defogCtrlOut_valid => FogRemoval_out2_valid
              );

  u_ContrastEnhancement : ContrastEnhancement
    PORT MAP( clk => clk,
              reset => reset,
              enb => clk_enable,
              pixelIn_0 => FogRemoval_out1_0,  -- uint8
              pixelIn_1 => FogRemoval_out1_1,  -- uint8
has popup