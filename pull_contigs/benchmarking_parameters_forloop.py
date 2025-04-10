import pandas as pd

for i in range(10):
    print(f"Processing sample {i}...")

    # File paths
    aligned_file = f"/home/lwang01/plasmids/CAMI2_Marine/CAMI2_reads/minimap2/CAMI2_mpSPAdes_aligned_contigs_{i}.txt"  # change for mp or megahit
    plasmid_file = f"/home/lwang01/plasmids/CAMI2_Marine/plasmid_contig_wrangling/plasmid_contig_ids_{i}.txt"  # do not change
    classifier_file = f"/home/lwang01/plasmids/CAMI2_Marine/CAMI2_reads/plasx/scores/anvio_contigs/CAMI2_mpSPAdes_plasmid_contigs_0.5_{i}.txt"

    # Load data
    aligned = pd.read_csv(aligned_file, sep='\t', header=None, names=["cami2_contig", "assembly_contig"])
    cami2_plasmids = pd.read_csv(plasmid_file, header=None, names=["cami2_plasmid_contigs"])
    classifier_plasmids = pd.read_csv(classifier_file, header=None, names=["classifier_plasmid_contigs"])

    # Mark CAMI2 and assembly minimap2 contigs as plasmids
    aligned["cami2_is_plasmid"] = aligned["cami2_contig"].isin(cami2_plasmids["cami2_plasmid_contigs"])
    aligned["assembly_is_plasmid"] = aligned["assembly_contig"].isin(classifier_plasmids["classifier_plasmid_contigs"])

    # Group by assembly contigs
    # this is creating a new df called assembly_classification where you're grouping assembly contigs by either CAMI2_is_plasmid or CAMI2_is_nonplasmid
    assembly_classification = aligned.groupby("assembly_contig").agg(
        cami2_has_plasmid=("cami2_is_plasmid", "any"),  # At least one CAMI2 contig is plasmid
        cami2_has_nonplasmid=("cami2_is_plasmid", lambda x: any(~x))  # At least one CAMI2 contig is non-plasmid
    ).reset_index()

    # Merge with classifier results
    # create a new column in assembly_classification
    # where it's the assembly contigs that are classified as plasmids by the classifier (vv in this case)
    assembly_classification["assembly_is_plasmid"] = assembly_classification["assembly_contig"].isin(classifier_plasmids["classifier_plasmid_contigs"])

    # Handle cases where an assembly contig has **both** plasmid and nonplasmid CAMI2 contigs
    #assembly_classification["cami2_final_label"] = assembly_classification["cami2_has_plasmid"]  # Use plasmid info first
    # If a contig has both plasmid & nonplasmid, we assume it's a plasmid (majority approach)
    #assembly_classification.loc[assembly_classification["cami2_has_nonplasmid"], "cami2_final_label"] = True

    # Calculate TP, TN, FP, FN
    TP = len(assembly_classification[(assembly_classification["assembly_is_plasmid"]) & (assembly_classification["cami2_has_plasmid"])])
    TN = len(assembly_classification[(~assembly_classification["assembly_is_plasmid"]) & (~assembly_classification["cami2_has_plasmid"])])
    FP = len(assembly_classification[(assembly_classification["assembly_is_plasmid"]) & (~assembly_classification["cami2_has_plasmid"])])
    FN = len(assembly_classification[(~assembly_classification["assembly_is_plasmid"]) & (assembly_classification["cami2_has_plasmid"])])

    # Print results
    print(f"Sample {i} - TP: {TP}, TN: {TN}, FP: {FP}, FN: {FN}\n")
