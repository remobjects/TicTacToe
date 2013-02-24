<?xml version="1.0" encoding="utf-8"?>
<Project DefaultTargets="Build" xmlns="http://schemas.microsoft.com/developer/msbuild/2003" ToolsVersion="4.0">
  <PropertyGroup>
    <RootNamespace>TicTacToe</RootNamespace>
    <ProjectGuid>f01dddaa-c382-4c3b-8209-5ca14ea7f011</ProjectGuid>
    <OutputType>Executable</OutputType>
    <AssemblyName>TicTacToe</AssemblyName>
    <AllowGlobals>False</AllowGlobals>
    <AllowLegacyWith>False</AllowLegacyWith>
    <AllowLegacyOutParams>False</AllowLegacyOutParams>
    <AllowLegacyCreate>False</AllowLegacyCreate>
    <AllowUnsafeCode>False</AllowUnsafeCode>
    <Configuration Condition="'$(Configuration)' == ''">Release</Configuration>
    <SDK>iOS</SDK>
    <CreateAppBundle>True</CreateAppBundle>
    <InfoPListFile>.\Resources\Info.plist</InfoPListFile>
    <DeploymentTargetVersion>
    </DeploymentTargetVersion>
    <Name>TicTacToe</Name>
    <DefaultUses />
    <StartupClass />
    <CreateHeaderFile>False</CreateHeaderFile>
    <BundleIdentifier>com.remobjects.oxygene.tictactoe</BundleIdentifier>
    <IRFilename>TicTacToe.ir</IRFilename>
  </PropertyGroup>
  <PropertyGroup Condition=" '$(Configuration)' == 'Debug' ">
    <Optimize>false</Optimize>
    <OutputPath>.\bin\Debug</OutputPath>
    <DefineConstants>DEBUG;TRACE;</DefineConstants>
    <GenerateDebugInfo>True</GenerateDebugInfo>
    <EnableAsserts>True</EnableAsserts>
    <TreatWarningsAsErrors>False</TreatWarningsAsErrors>
    <CaptureConsoleOutput>False</CaptureConsoleOutput>
    <WarnOnCaseMismatch>True</WarnOnCaseMismatch>
    <ProvisioningProfile>66FE4BE0-6416-4E3A-90FF-BC3A8D149D95</ProvisioningProfile>
    <ProvisioningProfileName>iOS Team Provisioning Profile: Wildcard AppID</ProvisioningProfileName>
    <CodesignCertificateName>iPhone Developer: marc hoffman (K2YTD84U6W)</CodesignCertificateName>
  </PropertyGroup>
  <PropertyGroup Condition=" '$(Configuration)' == 'Release' ">
    <Optimize>true</Optimize>
    <OutputPath>.\bin\Release</OutputPath>
    <GenerateDebugInfo>False</GenerateDebugInfo>
    <EnableAsserts>False</EnableAsserts>
    <TreatWarningsAsErrors>False</TreatWarningsAsErrors>
    <CaptureConsoleOutput>False</CaptureConsoleOutput>
    <WarnOnCaseMismatch>True</WarnOnCaseMismatch>
    <CreateIPA>True</CreateIPA>
  </PropertyGroup>
  <ItemGroup>
    <Reference Include="CoreGraphics.fx" />
    <Reference Include="Foundation.fx" />
    <Reference Include="GameKit.fx">
      <HintPath>C:\Program Files (x86)\RemObjects Software\Oxygene\Nougat\SDKs\iOS 6.1\GameKit.fx</HintPath>
    </Reference>
    <Reference Include="UIKit.fx" />
    <Reference Include="rtl.fx" />
  </ItemGroup>
  <ItemGroup>
    <Compile Include="AppDelegate.pas" />
    <Compile Include="Board.pas" />
    <Compile Include="Program.pas" />
    <Compile Include="RootViewController.pas" />
  </ItemGroup>
  <ItemGroup>
    <AppResource Include="Resources\Game Images\Grid%402x.png">
      <SubType>Content</SubType>
    </AppResource>
    <AppResource Include="Resources\Game Images\Grid.png">
      <SubType>Content</SubType>
    </AppResource>
    <AppResource Include="Resources\Game Images\Paper%402x.png">
      <SubType>Content</SubType>
    </AppResource>
    <AppResource Include="Resources\Game Images\Paper.png">
      <SubType>Content</SubType>
    </AppResource>
    <AppResource Include="Resources\Game Images\O1.png">
      <SubType>Content</SubType>
    </AppResource>
    <AppResource Include="Resources\Game Images\O1%402x.png">
      <SubType>Content</SubType>
    </AppResource>
    <AppResource Include="Resources\Game Images\X1%402x.png">
      <SubType>Content</SubType>
    </AppResource>
    <AppResource Include="Resources\Game Images\X1.png">
      <SubType>Content</SubType>
    </AppResource>
    <AppResource Include="Resources\Game Images\O2%402x.png">
      <SubType>Content</SubType>
    </AppResource>
    <AppResource Include="Resources\Game Images\O2.png">
      <SubType>Content</SubType>
    </AppResource>
    <AppResource Include="Resources\Game Images\O3%402x.png">
      <SubType>Content</SubType>
    </AppResource>
    <AppResource Include="Resources\Game Images\O3.png">
      <SubType>Content</SubType>
    </AppResource>
    <AppResource Include="Resources\Game Images\O4%402x.png">
      <SubType>Content</SubType>
    </AppResource>
    <AppResource Include="Resources\Game Images\O4.png">
      <SubType>Content</SubType>
    </AppResource>
    <AppResource Include="Resources\Game Images\O5%402x.png">
      <SubType>Content</SubType>
    </AppResource>
    <AppResource Include="Resources\Game Images\O5.png">
      <SubType>Content</SubType>
    </AppResource>
    <AppResource Include="Resources\Game Images\X2%402x.png">
      <SubType>Content</SubType>
    </AppResource>
    <AppResource Include="Resources\Game Images\X2.png">
      <SubType>Content</SubType>
    </AppResource>
    <AppResource Include="Resources\Game Images\X3%402x.png">
      <SubType>Content</SubType>
    </AppResource>
    <AppResource Include="Resources\Game Images\X3.png">
      <SubType>Content</SubType>
    </AppResource>
    <AppResource Include="Resources\Game Images\X4%402x.png">
      <SubType>Content</SubType>
    </AppResource>
    <AppResource Include="Resources\Game Images\X4.png">
      <SubType>Content</SubType>
    </AppResource>
    <AppResource Include="Resources\Game Images\X5%402x.png">
      <SubType>Content</SubType>
    </AppResource>
    <AppResource Include="Resources\Game Images\X5.png">
      <SubType>Content</SubType>
    </AppResource>
    <Content Include="Resources\Info.plist" />
    <AppResource Include="Resources\App Icons\App-29.png" />
    <AppResource Include="Resources\App Icons\App-48.png" />
    <AppResource Include="Resources\App Icons\App-57.png" />
    <AppResource Include="Resources\App Icons\App-58.png" />
    <AppResource Include="Resources\App Icons\App-72.png" />
    <AppResource Include="Resources\App Icons\App-96.png" />
    <AppResource Include="Resources\App Icons\App-114.png" />
    <AppResource Include="Resources\App Icons\App-144.png" />
    <None Include="Resources\App Icons\App-512.png" />
    <None Include="Resources\App Icons\App-1024.png" />
    <AppResource Include="Resources\Launch Images\Default.png" />
    <AppResource Include="Resources\Launch Images\Default@2x.png" />
    <AppResource Include="Resources\Launch Images\Default-568h@2x.png" />
  </ItemGroup>
  <ItemGroup>
    <Xib Include="RootViewController~ipad.xib" />
    <Xib Include="RootViewController~iphone.xib" />
  </ItemGroup>
  <ItemGroup>
    <Folder Include="Properties\" />
    <Folder Include="Resources\" />
    <Folder Include="Resources\App Icons\" />
    <Folder Include="Resources\Game Images\" />
    <Folder Include="Resources\Launch Images\" />
  </ItemGroup>
  <Import Project="$(MSBuildExtensionsPath)\RemObjects Software\Oxygene\RemObjects.Oxygene.Nougat.targets" />
  <PropertyGroup>
    <PreBuildEvent />
  </PropertyGroup>
</Project>