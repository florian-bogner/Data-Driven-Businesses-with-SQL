# Eniac & Magist: Is Magist a good fit for Eniac?

## About

In this project, we investigated whether Magist—a fictitious online retail platform—could open the door to Brazilian online retail for Eniac, an equally fictitious Spanish online marketplace for Apple products and accessories. In order to determine Magist's fit, we had to figure out whether Magist's marketplaces are a good place for expensive high-end tech products. Another thing to consider were shipping times: Are orders delivered fast enough?

## Method

We looked into the [Data](https://github.com/huschpuscheli/Magist_colab/blob/main/data/magist_dump.sql) to get a bigger picture of Magist's business characteristics are.

To get a basic understanding of the relation of the schema you can either look at the [PDF](https://github.com/huschpuscheli/Magist_colab/blob/main/data/magist_schema.pdf) or the [MySQL schema](https://github.com/huschpuscheli/Magist_colab/blob/main/data/magist_schema.mwb).

In the [Big picture script](https://github.com/huschpuscheli/Magist_colab/blob/main/scripts/Big%20picture.sql), we checked
1. how many orders were placed and ordered in the given time frame,
2. whether Magist has user growth,
3. what Magist's product range and product categories are,
4. whether all products offered were actually part of an order and
5. what the price ranges of products and order payments are
to get a basic understanding of the Magist marketplace.

After that, we dove deeper into the data in order to answer to questions:
- Is Magist a good fit for high-end tech products?
	1. What categories of tech products does Magist have?
	2. How many products of these tech categories have been sold (within the time window of the database snapshot)? What percentage does that represent from the overall number of products sold?
	3. What’s the average price of the products being sold?
	4. Are expensive tech products popular?
	5. How many sellers are there?
	6. What’s the average monthly revenue of Magist’s sellers?
	7. What’s the average revenue of sellers that sell tech products?
- Are orders delivered on time?
	8. What’s the average time between the order being placed and the product being delivered?
	9. How many orders are delivered on time vs orders delivered with a delay?
	10. Is there any pattern for delayed orders, e.g. big products being delayed more often?

## Results
Our results are shown in our [Presentation](https://github.com/huschpuscheli/Magist_colab/blob/main/presentation/Magist%20-%20Is%20it%20a%20good%20partner%20for%20Eniac%3F.pptx).

## Conclusion
We cannot recommend Magist as an online marketplace for Eniac's business expansion in Brazil.