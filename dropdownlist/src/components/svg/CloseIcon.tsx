import React, { ReactElement } from "react";

const CloseIcon = (): ReactElement<HTMLOrSVGElement> => {
  return (
    <svg
      xmlns="http://www.w3.org/2000/svg"
      width="17"
      height="17"
      viewBox="0 0 17 17"
      fill="none"
    >
      <path
        fillRule="evenodd"
        clipRule="evenodd"
        d="M8.5 0.5C4.076 0.5 0.5 4.076 0.5 8.5C0.5 12.924 4.076 16.5 8.5 16.5C12.924 16.5 16.5 12.924 16.5 8.5C16.5 4.076 12.924 0.5 8.5 0.5ZM8.5 14.9C4.972 14.9 2.1 12.028 2.1 8.5C2.1 4.972 4.972 2.1 8.5 2.1C12.028 2.1 14.9 4.972 14.9 8.5C14.9 12.028 12.028 14.9 8.5 14.9ZM8.5 7.372L11.372 4.5L12.5 5.628L9.628 8.5L12.5 11.372L11.372 12.5L8.5 9.628L5.628 12.5L4.5 11.372L7.372 8.5L4.5 5.628L5.628 4.5L8.5 7.372Z"
        fill="#1E334C"
      />
    </svg>
  );
};

export default CloseIcon;
