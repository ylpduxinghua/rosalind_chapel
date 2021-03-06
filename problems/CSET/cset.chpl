module CHBP {
  // Character-Based Phylogen
  // http://rosalind.info/problems/chbp/
  const defaultfilename="none";
  config const infile=defaultfilename;

  const empty_set: domain(string);

  // use stdin if filename == defaultfilename
  iter lines_from_file(filename: string, defaultfilename: string) throws {
    var channel = stdin;

    if infile != defaultfilename {
      var file = open(infile, iomode.r);
      channel = file.reader();
    }

    var line: string;
    while (channel.readline(line)) do
      yield line.strip();
  }

  class Partition {
    // A partition of a list of labels, generated by either a set of labels
    // or a charactable entry (a string of labels.size 0s and 1s)
    var set, complement: domain(string);

    proc init(labels, char_table_line="", set_labels=empty_set) {
      const universe : domain(string) = labels;
      set = empty_set; // this is absurd but I don't see how else to initialize the empty set.

      if (char_table_line != "") {
        for (i, char) in zip(1.., char_table_line) do
          if char == '0' then
            set.add(labels[i]);
      } else {
        set.add(set_labels);
      }
      complement = universe - set;
    }

    proc size_diff() {
      return abs(set.size() - complement.size());
    }

    proc contains_null() {
      return (set.size() == 0) || (complement.size() == 0);
    }

    proc intersections(other) {
      return [set & other.set, set & other.complement,
              complement & other.set, complement & other.complement];
    }

    proc consistent_with(other) {
      const overlaps = for ins in intersections(other) do if ins.size == 0 then ins.size;
      return overlaps.size != 0;
    }

    proc subdivides(labels) {
      // Does this partition divide the labels provided?
      const labelset : domain(string) = labels;
      const set_overlap = set & labelset;

      if ((set_overlap.size == 0) || (set_overlap.size == labelset.size)) then
        return false;

      return true;
    }

    proc as_character_table(labels) {
      var line = "";
      for lab in labels do
        if set.member(lab) then
          line += "0";
        else
          line += "1";

      return line;
    }

  }

  proc consistency_matrix(partitions) {
    const n = partitions.size;
    var consistent: [1..n, 1..n] bool = true;

    for i in 1..n-1 {
      var p = partitions[i];
      for j in i+1..n do {
        var q = partitions[j];
        consistent[i, j] = p.consistent_with(q);
        consistent[j, i] = consistent[i, j];
      }
    }

    return consistent;
  }

  proc worst_offender(n, consistent) {
    var ninconsistent : [1..n] int = 0;

    for i in 1..n do
      ninconsistent[i] = n - (+ reduce consistent[i, 1..n]);

    return maxloc reduce zip(ninconsistent, ninconsistent.domain);
  }

  proc main() {
    try! {
      const characters = lines_from_file(infile, defaultfilename);
      var n = characters.size;
      const nlabels = characters[1].size;
      const labels = [i in 1..nlabels] ""+i;

      var partitions : [1..n] Partition = [ch in characters] new unmanaged Partition(labels, char_table_line = ch);

      var worst, worstscore : int;
      worstscore = 100;

      while (worstscore > 0) {
        const consistent = consistency_matrix(partitions);
        (worstscore, worst) = worst_offender(n, consistent);

        if (worstscore > 0) {
          partitions.remove(worst);
          n -= 1;
        }
      }

      for p in partitions do
        writeln(p.as_character_table(labels));
    }
  }
}
