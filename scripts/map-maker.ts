import getPixels from "get-pixels";
import fs from "fs";

const mapName = process.env.MAP_NAME;

enum TileType {
  NORMAL = "TileType.NORMAL",
  START = "TileType.START",
  WALL = "TileType.WALL",
}
getPixels(`./maps/${mapName}`, async (err, pixels) => {
  if (err) {
    console.log("err " + err);
  }

  let mapString = "";
  let mapJSON = [];
  let rowJSON = [];

  let maxHeight = 0;
  let maxWidth = 0;

  const width = pixels.pick(1, null, 1).shape[0];
  const height = pixels.pick(null, 1, 1).shape[0];
  for (let i = 0; i < width; i++) {
    for (let j = 0; j < height; j++) {
      let pixelValue = pixels.pick(j, null, 1).get(i);
      if (pixelValue == 0) {
        rowJSON.push(TileType.WALL);
        mapString = mapString + " 000";
      } else if (pixelValue == 158) {
        rowJSON.push(TileType.WALL);
        mapString = mapString + " " + pixels.pick(j, null, 1).get(i).toString();
      } else if (pixelValue == 240) {
        rowJSON.push(TileType.NORMAL);
        mapString = mapString + " " + pixels.pick(j, null, 1).get(i).toString();
      } else if (pixelValue == 169) {
        rowJSON.push(TileType.START);
        mapString = mapString + " " + pixels.pick(j, null, 1).get(i).toString();
      } else {
        rowJSON.push(TileType.WALL);
        mapString = mapString + " " + pixels.pick(j, null, 1).get(i).toString();
      }
    }
    mapJSON.push(rowJSON);
    rowJSON = [];
    mapString = mapString + "\n";
  }
  fs.writeFile("./maps/room.txt", mapString, (err) => {
    if (err) {
      return console.log(err);
    }
  });

  fs.writeFile("./maps/room.json", JSON.stringify(mapJSON), (err) => {
    if (err) {
      return console.log(err);
    }
  });


  let startCoordinates = [];
  console.log('hello')
  console.log(mapJSON.length)
  console.log(mapJSON[0].length)
  for(let i = 0; i < mapJSON.length; i++)
  {
    for(let j = 0; j < mapJSON[0].length; j++)
    { 
      if(mapJSON[i][j] == TileType.START)
      {
        console.log(`${i} ${j}`)
      }
    }
  }
});
