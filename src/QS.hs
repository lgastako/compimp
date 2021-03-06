{-# LANGUAGE RankNTypes #-}
module QS where

import           Prelude                  hiding ( read )

import           Control.Monad
import           Control.Monad.ST
import           Data.List                       ( sortOn )
import           Data.STRef
import           Data.Vector                     ( freeze
                                                 , fromList
                                                 , thaw
                                                 , toList
                                                 )
import qualified Data.Vector         as V        ( Vector
                                                 , length
                                                 )
import           Data.Vector.Mutable             ( STVector
                                                 , read
                                                 , swap
                                                 , write
                                                 )
import           System.Random

partitionFirst array l r = do
    p <- read array l
    i <- newSTRef (l+1)
    forM_ [l+1..(r-1)] $ \j -> do
        arrayJ <- read array j
        i'     <- readSTRef i
        when (arrayJ < p) $ do
            swap array i' j
            modifySTRef' i (+1)
    i' <- readSTRef i
    swap array (i'-1) l
    return (i'-1)

partitionLast array l r = do
    swap array (r-1) l
    partitionFirst array l r

partitionMedian array l r = do
    p <- chooseMedian array l r
    swap array p l
    partitionFirst array l r

chooseMedian array l r = do
    h <- read array l
    t <- read array (r-1)
    let len = r-l
    let mid = if (len `mod` 2) == 0
        then l + (len `div` 2) - 1
        else l + (len `div` 2)
    m <- read array mid
    let options = sortOn snd [(l, h), (mid, m), (r-1, t)]
    return (fst (options !! 1))

quicksort array start end partition comparisons = when (start < end) $ do
    i <- partition array start end
    modifySTRef' comparisons (+ (end-start-1))
    quicksort array start i   partition comparisons
    quicksort array (i+1) end partition comparisons

quicksort' :: Ord a =>
              V.Vector a ->
              (forall s a. (Ord a) => STVector s a -> Int -> Int -> ST s Int)
              -> Int
quicksort' vector partition = runST $ do
    array  <- thaw vector
    comps  <- newSTRef 0
    quicksort array 0 (V.length vector) partition comps
    readSTRef comps

generateRandomContents :: Int -> IO [Int]
generateRandomContents n = sequence $ replicate n $ randomRIO (minBound, maxBound::Int)

runQS = do
  contents <- generateRandomContents 1000000
  let vector = fromList contents

      pfResult = quicksort' vector partitionFirst
      plResult = quicksort' vector partitionLast
      pmResult = quicksort' vector partitionMedian

      results = [pfResult, plResult, pmResult]

  putStrLn $ "Results: " ++ show results

