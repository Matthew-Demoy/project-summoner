import getPixels from "get-pixels";
import fs from "fs";

const mapName = process.env.MAP_NAME;

getPixels(`./maps/${mapName}`, (err, pixels) => {
  if (err) {
    console.log("err " + err);
  }

  const height = pixels.shape[1];
  const width = pixels.shape[0];

  let maxWidth = 0;
  
  console.log(pixels.get(0,0))



  
  fs.writeFile("./maps/room.json", pixels.hi(width,height,1).data.toString(), (err) => {
      if(err){
          return console.log(err);
      }

  })

  const temp  = pixels.data.slice(32 * 32);
  console.log(temp)

  for(let i = 0; i < height; i++)
  {
      
    const row = pixels.lo(0, 1).hi(width, 1)

    for(let j = 0; j < width; j++)
    {
        if(pixels.get(j, 0) !== 0 && pixels.get(j, 0) !== undefined)
        {
            console.log(pixels.get(j, i))
        }
    }

    
  }
  
});
