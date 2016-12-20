#!/usr/bin/env python 
import argparse
import numpy as np
import pandas as pd 
import skfeature
#from import ... skfeature
from skfeature.function.similarity_based import fisher_score, reliefF
from skfeature.function.statistical_based import f_score


def main(args):
  X, y, feature_names = preprocess(args.data, args.labels)

  if args.algorithm == 'relief':
    score_relief = reliefF.reliefF(X, y)
    idx_relief = reliefF.feature_ranking(score_relief)
    print_features('Relief', idx_relief[:args.select], feature_names)
  elif args.algorithm == 'fisher':
    score_fisher = fisher_score.fisher_score(X, y)
    idx_fisher = fisher_score.feature_ranking(score_fisher)
    print_features('Fisher Score', idx_fisher[:args.select], feature_names)
  elif args.algorithm == 'f_score':
    score_f_score = f_score.f_score(X, y)
    idx_f_score = f_score.feature_ranking(score_fisher)
    print_features('f_score', idx_fisher[:args.select], feature_names)
  return None 

def print_features(algorithm, indices, feature_names): 
  print 'Features selected by ' + algorithm
  n = 1
  for i in indices: 
    print ' > ' + feature_names[i] + ' (Rank ' + str(n) + ')'
    n += 1

  print ' '
  return None 

def preprocess(matrix_file_name, label_file_name):
  '''
  Read in the data from the matrix and label file then rearrange the 
  columns labels to make sure they correspond with the correct sample
  in the data matrix

  Returns
    X: data matrix
    y: label vector
  '''
  # get the data from the data file
  df_data = pd.read_csv(matrix_file_name, sep='\t')
  col_names = df_data.keys()
  col_data = df_data.as_matrix()
  row_names = np.array(list(df_data.index))

  # get the data from the map file 
  df_maps = pd.read_csv(label_file_name, sep='\t')
  outcomes = list(df_maps['outcome'])
  names = list(df_maps['name'])

  # convert the data to a common format for sklearn
  data = col_data.copy()
  labels = []

  for col in col_names:
    n = 0
    for col_map in df_maps['name']:
      if col_map == col:
        break
      else:
        n += 1
      
    if len(range(n)) != 0:
      for m in range(n):
        tmp_lab = df_maps['outcome'][m]
    else:
      tmp_lab = df_maps['outcome'][0]
          
    if tmp_lab == 'P':
      labels.append(1)
    else:
      labels.append(-1)
  
  y = np.array(labels)
  X = data.transpose()
  return X, y, row_names

def build_parser():
  '''
  Build the option parser. 
  '''
  parser = argparse.ArgumentParser(
    description=("This script performs feature selection on Cricket's data "
      "from DoA. You need to install the following libraries to use this "
      " script: \n"
      "Numpy (http://www.numpy.org/) \n" 
      "Pandas (http://pandas.pydata.org/) \n"
      "Scikit Feature Selection (http://featureselection.asu.edu/)\n")
  )
  parser.add_argument("-n", "--select",
    type=int,
    help="number of features to select",
    default=100)
  parser.add_argument("-d", "--data",
    help="the input file that has the data matrix",
    required=True)
  parser.add_argument("-l", "--labels",
    help="the input file that has the labels",
    required=True)
  parser.add_argument("-a", "--algorithm",
    help="feature selection algorithm to use (relief; fisher)",
    default="relief")


  return parser

if __name__ == '__main__': 
  parser = build_parser()
  args = parser.parse_args()
  main(args)
