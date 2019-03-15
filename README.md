# LazyRunner

A powershell script to perform simple administrative operations based on configuration file.

## Configuration options

#### Assemblies

For custom assemblies:
```
{ "key": "path", "value": "%%SCRIPT_RELATIVE%%\\assemblies\\assembly.dll" }
```
For assemblies in DAC:
```
{ "key": "name", "value": "Microsoft.SQLServer.ManagedDTS, Version=13.0.0.0, Culture=neutral, PublicKeyToken=89845dcd8080cc91" }
```

#### Setup Folder Structure

```
{
  "type": "SetupFolderStructure",
  "actions": [
    {
      "root": "C:\\Test",
      "children": [
        {
          "name": "My Files",
          "children": [
            {
              "name": "New Files", "children": []
            },{
              "name": "Archived Files", "children": [
                { "name": "Archived on %%CURRENTDATE%%", "children": [] }
              ]
            },{
              "name": "Trash", "children": []
            }
          ]
        }
      ]
    }
  ]
}
```

#### Folder Manipulations

```
{
  "type": "MoveFolders",
  "actions": [
    {
      "action": "delete",
      "sourceFolder": "C:\\Test\\My Files\\Trash"
    },
    {
      "action": "move",
      "replaceExisting": false,
      "sourceFolder": "C:\\Test\\My Files\\New Files",
      "destinationFolder": "C:\\Test\\My Files\\Archived Files\\Archived on %%CURRENTDATETIME%%"
    }
  ]
}
```

