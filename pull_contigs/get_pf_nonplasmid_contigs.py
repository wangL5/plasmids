import os 

# get nonplasmid contigs 
# some plasmid classifiers only produce plasmid contigs.
# this script identifies non-plasmid contigs by looking at the difference between classifier plasmid contigs and assembly contigs 

# establish paths 
# classifier plasmids: what the plasmid classifier identified as plasmid contigs
classifier_plasmids_dir="/work/NRSAAMR/Projects/plasmids/CAMI2_Marine/CAMI2_reads/plasmidfinder_run2/plasmidfinder_mpSPAdes_plasmid_contigs"
# assembly contigs: all contigs from megahit assembly 
megahit_contigs_dir="/work/NRSAAMR/Projects/plasmids/CAMI2_Marine/CAMI2_reads/megahit_contig_lists"
mpSPAdes_contigs_dir="/work/NRSAAMR/Projects/plasmids/CAMI2_Marine/CAMI2_reads/mpSPAdes_contig_lists"

# function that will read in contig lists
def read_in_lists(directory):
    # initialize list 
    contig_list = []
    for filename in sorted(os.listdir(directory)):
        file_path = os.path.join(directory, filename)
        with open(file_path, 'r') as file:
            # add these contig files to the list
            contig_list.append([line.strip() for line in file])
    return contig_list

# load in lists of contigs
classifier_plasmids = read_in_lists(classifier_plasmids_dir)
assembly_contigs = read_in_lists(mpSPAdes_contigs_dir)

# do the two lists have the same number of entries?
if len(classifier_plasmids) != len(assembly_contigs):
    raise ValueError("The two contig lists do not have the same number of lists")

# initiate a list for nonplasmid contigs 
nonplasmid_list = []

# go through the two lists
for list1, list2 in zip(classifier_plasmids, assembly_contigs):
    # find unshared contigs using set difference
    non_plasmids = list(set(list2) - set(list1)) 
    # add the non_plasmid contig list to the nonplasmid_list
    nonplasmid_list.append(non_plasmids)

# produce individual nonplasmid contig lists
output_dir = "/work/NRSAAMR/Projects/plasmids/CAMI2_Marine/CAMI2_reads/plasmidfinder_run2"
os.makedirs(output_dir, exist_ok=True) # does the output dir exist

for n, sublist in enumerate(nonplasmid_list):
    filename = f"plasmidfinder_mpSPAdes_nonplasmid_{n}.txt"
    output_path = os.path.join(output_dir, filename)
    with open(output_path, 'w') as file:
        # convert each sublist item into a string using map()
        file.write('\n'.join(map(str, sublist)) + '\n')
    print(f"Saved: {output_path}")

print("All done")



