test:
    v test .

doc:
    v doc -f md . -o src
    v doc -m -f html . -o docs_html
