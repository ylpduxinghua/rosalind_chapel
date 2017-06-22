module DNA {
  const defaultfilename="none";
  config const infile=defaultfilename;

  // read file into a single string 
  // use stdin if filename == defaultfilename
  proc string_from_file(filename: string, defaultfilename: string) : string {
    var text: string = "";
    var line: string = "";

    var channel = stdin;
    if infile != defaultfilename {
      var file = open(infile, iomode.r);
      channel = file.reader();
    }

    while (channel.read(line)) do 
      text = text + line;

    return text;
  }

  proc transcribe(line: string) {
    return line.replace("T", "U");
  }

  proc main() {
    var dna = string_from_file(infile, defaultfilename);
    var rna = transcribe(dna);

    writeln(rna);
  }
}
